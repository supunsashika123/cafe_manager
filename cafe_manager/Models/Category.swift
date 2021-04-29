//
//  Category.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-29.
//

import Foundation
import FirebaseFirestoreSwift

struct Category:Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
}
