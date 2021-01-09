//
//  GoodsViewModel.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 07.01.2021.
//

import UIKit
import Moya
import SnapKit
import Foundation

class GoodsViewModel {
    
//    MARK: Public Properties
    
    public var isUpdating: ((Bool) -> ())?
    public var onError: ((String) -> ())?
    public var onLoadImage: ((Int) -> ())?
    
    public var itemsCount: Int {
        return goods.reduce(0) {$0 + $1.count}
    }
    
    public var goodsToBuy: [Good] {
        return goods.filter {$0.count > 0}
    }
    
//    MARK: Private Properties
    
    private(set) var goods: [Good] = []
    
    private let provider = MoyaProvider<ProjectEndpoints>(plugins: [NetworkLoggerPlugin()])
    
    private let userDefaults = UserDefaults.standard
    
//    MARK: Actions
    
    public func commitChanges() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(goodsToBuy){
           UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.goods.rawValue)
        }
    }
    
    public func reloadData() {
        isUpdating?(true)
        
        let resp: GoodsResponse = loadFromFile("Goods.json")
        goods = resp.goods
        let previousGoodsToBuy = loadFromUserDefaults()
        for good in previousGoodsToBuy {
            goods.first { $0.id == good.id }?.count = good.count
        }
        
        for (index, good) in goods.enumerated() {
            loadImage(URL(string: good.imageLink)!) { [weak self] image in
                good.image = image
                self?.onLoadImage?(index)
            }
        }
        isUpdating?(false)
    }
    
    private func loadFromUserDefaults() -> [Good] {
        guard let goodsEncoded = userDefaults.value(forKey: UserDefaultsKeys.goods.rawValue) as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let goodsDecoded = try? decoder.decode(Array.self, from: goodsEncoded) as [Good] else { return [] }
        return goodsDecoded
    }
    
    private func loadImage(_ url: URL, onComplete: @escaping ((UIImage?) -> ())) {
        provider.request(.image(url: url)) { result in
            switch result {
                case .success(let response):
                    onComplete(UIImage(data: response.data))
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    onComplete(nil)
            }
        }
    }
    
    private func loadFromFile<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

