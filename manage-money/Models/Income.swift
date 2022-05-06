//
//  Income.swift
//  manage-money
//
//  Created by Thu Tinh on 05/05/2022.
//

import Foundation

struct Income: Decodable {
    var username: String?
    var name: String?
    var date: String?
    var income: Double?
    var type: String?

    init(username: String, name: String, date: String, income: Double, type: String ){
        self.username = username
        self.name = name
        self.date = date
        self.income = income
        self.type = type
    }
}
