//
//  Item.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-26.
//

import Foundation

struct Item:Identifiable, Codable {
    var id: String? = UUID().uuidString
    var name: String
    var qty: Int
    var total: Float
    
    func convertToDictionary() -> [String : Any] {
        let dic: [String: Any] = [
            "name":self.name,
            "qty":self.qty,
            "total":self.total
        ]
        return dic
    }
}
