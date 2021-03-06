//
//  GoodCell.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 07.01.2021.
//

import UIKit
import SnapKit

class GoodCell: UITableViewCell, CellInstantiable {
    
//    MARK: Public Properties
    
    public var onAddButtonClick: (() -> ())?
    public var onRemoveButtonClick: (() -> ())?
    public var onDeleteButtonClick: (() -> ())?
    
    
//    MARK: Private Properties
    
    private var count: Int = 0 {
        didSet {
            countLabel.text = "\(count) шт."
            if count == 0 && oldValue > 0 {
                cartButton.isHidden = false
                
                countLabel.isHidden = true
                addButton.isHidden = true
                removeButton.isHidden = true
            } else if oldValue == 0 && count > 0 {
                cartButton.isHidden = true
                
                countLabel.isHidden = false
                addButton.isHidden = false
                removeButton.isHidden = false
            }
        }
    }
    
//    MARK: UIElements
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var goodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var goodTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var goodPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        button.setTitle("+", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        button.isHidden = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        button.setTitle("-", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(removeFromCart), for: .touchUpInside)
        button.isHidden = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "trash").withTintColor(.red), for: .normal)
        button.addTarget(self, action: #selector(deleteFromCart), for: .touchUpInside)
        button.isHidden = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
//    MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.addShadow(
            withColor: .black,
            opacity: 0.5,
            radius: 5,
            xOffset: 1,
            yOffset: 1)
    }
    
//    MARK: Set
    
    public func set(_ good: Good, needShowDeleteButton: Bool = false) {
        backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.5568627451, blue: 0.2352941176, alpha: 1)
        goodTitleLabel.text = good.title
        goodPriceLabel.text = "\(good.price) Р"
        goodImageView.image = good.image ?? #imageLiteral(resourceName: "noImage")
        count = good.count
        deleteButton.isHidden = !needShowDeleteButton
        setup()
    }
    
//    MARK: Private Methods
    
    private func setup() {
        
        addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        shadowView.addSubview(goodImageView)
        goodImageView.snp.makeConstraints { make in
            make.width.height.equalTo(125)
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        shadowView.addSubview(goodPriceLabel)
        goodPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(goodImageView)
            make.leading.equalTo(goodImageView.snp.trailing).offset(10)
        }
        
        shadowView.addSubview(goodTitleLabel)
        goodTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(goodPriceLabel.snp.bottom).offset(5)
            make.leading.equalTo(goodImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        shadowView.addSubview(cartButton)
        cartButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(goodTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(goodImageView.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        shadowView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(goodTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(goodImageView.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        shadowView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(removeButton)
            make.leading.equalTo(removeButton.snp.trailing).offset(5)
        }
        
        shadowView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(removeButton)
            make.leading.equalTo(countLabel.snp.trailing).offset(5)
        }
        
        shadowView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(removeButton)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.greaterThanOrEqualTo(addButton.snp.trailing).offset(10)
            make.height.equalTo(removeButton).multipliedBy(0.7)
            make.width.equalTo(deleteButton.snp.height).multipliedBy(0.9)
        }
    }
    
    @objc private func addToCart(sender: UIButton!) {
        count += 1
        onAddButtonClick?()
    }
    
    @objc private func removeFromCart(sender: UIButton!) {
        count -= 1
        onRemoveButtonClick?()
    }
    
    @objc private func deleteFromCart(sender: UIButton!) {
        count = 0
        onDeleteButtonClick?()
    }
}
