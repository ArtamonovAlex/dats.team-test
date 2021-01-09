//
//  AppCoordinator.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 08.01.2021.
//

import UIKit

class AppCoordinator {
    
//    MARK: Properties
    public var window: UIWindow!
    
    private var navigationController: UINavigationController!
    
//    MARK: Init
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    public func start() {
        window.rootViewController = navigationController
        showGoods()
    }
    
//    MARK: Private Methods
    
    func showGoods() {
        let vc = GoodsViewController()
        vc.viewModel = GoodsViewModel()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    private func showCart(goods: [Good]) {
        let vc = OrderViewController()
        vc.viewModel = OrderViewModel(goods)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: GoodsViewControllerDelegate {
    func openCart(_ goods: [Good]) {
        showCart(goods: goods)
    }
}
