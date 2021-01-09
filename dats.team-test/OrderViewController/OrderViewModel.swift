//
//  OrderViewModel.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 08.01.2021.
//

import UIKit

class OrderViewModel {
    
//    MARK: Private Properties
    
    private(set) var goods: [Good]
    
    private let userDefaults = UserDefaults.standard
    
//    MARK: Private Properties
    
    public var totalPrice: Int {
        return goods.reduce(0) {$0 + $1.count * $1.price}
    }
    
//    MARK: Init
    
    init(_ goods: [Good]) {
        self.goods = goods
    }
    
//    MARK: Actions
    
    public func removeGood(with id: Int) {
        goods.removeAll { $0.id == id }
    }
    
    public func encodeGoods() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(goods)
    }
    
    public func commitChanges() {
        if let encoded = encodeGoods() {
           UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.goods.rawValue)
        }
    }
}
