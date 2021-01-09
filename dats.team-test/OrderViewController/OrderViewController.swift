//
//  OrderViewController.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 08.01.2021.
//

import UIKit

class OrderViewController: BaseViewController {
    
    //    MARK: Public Properties
        
    public var viewModel: OrderViewModel!
    
    //    MARK: UIElements
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(GoodCell.self, forCellReuseIdentifier: GoodCell.reuseId)
        return table
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.368627451, blue: 0.1254901961, alpha: 1)
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        label.text = "Итого"
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return label
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        button.setTitle("Сделать заказ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(createOrder), for: .touchUpInside)
        return button
    }()
    
//    MARK: Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ваш заказ"
        totalPriceLabel.text = "\(viewModel.totalPrice) Р"
        if viewModel.goods.isEmpty {
            self.orderButton.isEnabled = false
            self.orderButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.addShadow(
            withColor: .black,
            opacity: 0.5,
            radius: 5,
            xOffset: 1,
            yOffset: 2)
    }
    
//    MARK: Private Methods
    
    private func setup() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(5)
        }
        
        shadowView.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        shadowView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalPriceLabel)
            make.leading.equalToSuperview().offset(20)
        }
        
        shadowView.addSubview(orderButton)
        orderButton.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func createOrder(sender: UIButton!) {
        if let encoded = viewModel.encodeGoods() {
            let jsonString = String(data: encoded, encoding: .utf8)!
            self.presentAlert(withTitle: "Ваш заказ", message: jsonString)
        } else {
            self.presentAlert(withTitle: "Произошла ошибка", message: nil)
        }
    }
}

// MARK: UITableViewDataSource

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodCell = tableView.dequeueReusableCell(withIdentifier: GoodCell.reuseId, for: indexPath) as! GoodCell
        let good = viewModel.goods[indexPath.row]
        cell.set(good, needShowDeleteButton: true)
        cell.contentView.isUserInteractionEnabled = false
        cell.onAddButtonClick = { [weak self] in
            guard let self = self else { return }
            good.count += 1
            self.totalPriceLabel.text = "\(self.viewModel.totalPrice) Р"
            self.viewModel.commitChanges()
        }
        cell.onRemoveButtonClick = { [weak self] in
            guard let self = self else { return }
            good.count -= 1
            if good.count == 0 {
                self.viewModel.removeGood(with: good.id)
                self.tableView.reloadData()
            }
            self.totalPriceLabel.text = "\(self.viewModel.totalPrice) Р"
            if self.viewModel.goods.isEmpty {
                self.orderButton.isEnabled = false
                self.orderButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            self.viewModel.commitChanges()
        }
        cell.onDeleteButtonClick = { [weak self] in
            guard let self = self else { return }
            good.count = 0
            self.viewModel.removeGood(with: good.id)
            self.tableView.reloadData()
            self.totalPriceLabel.text = "\(self.viewModel.totalPrice) Р"
            if self.viewModel.goods.isEmpty {
                self.orderButton.isEnabled = false
                self.orderButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            self.viewModel.commitChanges()
        }
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension OrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
