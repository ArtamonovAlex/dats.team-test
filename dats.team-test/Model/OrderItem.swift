//
//  OrderItem.swift
//  dats.team-test
//
//  Created by Валерия Самонина on 08.01.2021.
//

import Foundation

class OrderItem: Encodable {
    public var good: Good
    public var count: Int
    
    init(good: Good, count: Int = 0) {
        self.good = good
        self.count = count
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, count
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(good.id, forKey: .id)
        try container.encodeIfPresent(count, forKey: .count)
    }
    
}
