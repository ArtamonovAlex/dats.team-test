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
    
    private func showGoods() {
        let vc = GoodsViewController()
        vc.viewModel = GoodsViewModel()
        vc.delegate = self
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showCart(goods: [Good]) {
        let vc = OrderViewController()
        vc.viewModel = OrderViewModel(goods)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: GoodsViewControllerDelegate {
    func openCart(_ controller: GoodsViewController) {
        showCart(goods: controller.viewModel.goods.filter {$0.count > 0})
    }
    
    
}
