//
//  Cost.swift
//  manage-money
//
//  Created by Thu Tinh on 05/05/2022.
//

import Foundation


struct Cost: Decodable {
    var username: String?
    var name: String?
    var date: String?
    var cost: Double?
    var type: String?
    var costType: String?

    init(username: String, name: String, date: String, cost: Double, type: String, costType: String ){
        self.username = username
        self.name = name
        self.date = date
        self.cost = cost
        self.type = type
        self.costType = costType
        
    }
}
