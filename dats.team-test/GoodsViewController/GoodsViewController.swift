//
//  GoodsViewController.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 07.01.2021.
//

import UIKit
import SnapKit

protocol GoodsViewControllerDelegate {
    func openCart(_ controller: GoodsViewController)
}

class GoodsViewController: BaseViewController {

    //    MARK: Public Properties
        
    public var viewModel: GoodsViewModel!
    
    public var delegate: GoodsViewControllerDelegate?
    
    //    MARK: Private Properties
        
    private var orderItemsCount: Int = 0 {
        didSet {
            if orderItemsCount < 1 {
                cartItemsView.isHidden = true
            } else {
                cartItemsView.isHidden = false
                cartItemsLabel.text = String(orderItemsCount)
            }

        }
    }
        
    //    MARK: UIElements
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 9, bottom: 12, right: 11)
        button.setImage(#imageLiteral(resourceName: "Cart").withTintColor(.white), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartItemsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var cartItemsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(GoodCell.self, forCellReuseIdentifier: GoodCell.reuseId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Товары"
        
        orderItemsCount = 0
        setup()
        bindViewModel()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderItemsCount = viewModel.itemsCount
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cartButton.addShadow(
            withColor: .black,
            opacity: 0.5,
            radius: 5,
            xOffset: 1,
            yOffset: 2)
    }
    
    private func setup() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
        }
        
        view.addSubview(cartButton)
        cartButton.snp.makeConstraints { m in
            m.trailing.equalToSuperview().offset(-20)
            m.bottom.equalToSuperview().offset(-30)
        }
        
        view.addSubview(cartItemsView)
        cartItemsView.snp.makeConstraints { m in
            m.top.equalTo(cartButton.snp.bottom).offset(-12)
            m.leading.equalTo(cartButton.snp.trailing).offset(-20)
        }
        
        cartItemsView.addSubview(cartItemsLabel)
        cartItemsLabel.snp.makeConstraints { m in
            m.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
    }
    
    private func reloadData() {
        viewModel.reloadData()
    }
    
    private func bindViewModel() {
        
        viewModel.onLoadImage = { [weak self] index in
            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    
    @objc private func openCart(sender: UIButton!) {
        delegate?.openCart(self)
    }
}

extension GoodsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodCell = tableView.dequeueReusableCell(withIdentifier: GoodCell.reuseId, for: indexPath) as! GoodCell
        let good = viewModel.goods[indexPath.row]
        cell.set(good)
        cell.contentView.isUserInteractionEnabled = false
        cell.onAddButtonClick = {
            self.orderItemsCount += 1
            good.count += 1
            self.viewModel.commitChanges()
        }
        cell.onRemoveButtonClick = {
            self.orderItemsCount -= 1
            good.count -= 1
            self.viewModel.commitChanges()
        }
        return cell
    }
    
}

extension GoodsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
