//
//  FoodItem.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-30.
//

import Foundation
import FirebaseFirestoreSwift
 
struct FoodItem:Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var image: String
    var price: Float
    var category: Category
    var available: Bool
}
