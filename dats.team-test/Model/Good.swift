//
//  Good.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 07.01.2021.
//

import UIKit

class Good: Codable {

    public let id: Int
    public let title: String
    public let imageLink: String
    public let price: Int
    
    public var image: UIImage? = nil
    public var count: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, title, imageLink, price, count
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try! container.decodeIfPresent(String.self, forKey: .title) ?? ""
        imageLink = try! container.decodeIfPresent(String.self, forKey: .imageLink) ?? ""
        price = try! container.decodeIfPresent(Int.self, forKey: .price) ?? 0
        count = try! container.decodeIfPresent(Int.self, forKey: .count) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(count, forKey: .count)
    }
}

