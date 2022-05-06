//
//  constants.swift
//  manage-money
//
//  Created by Thu Tinh on 21/04/2022.
//

import Foundation

class Constants {
    static let host = "http://localhost:3000"
    static let uploadFileUrl = host + "/uploads-file"
    static let loginUrl = host + "/login"
    static let registerUrl = host + "/register"
    static let addIncome = host + "/incomes/add"
    static let addExpense = host + "/costs/add"
    static let getCostByDate = host + "/costs/date/"
    static let getIncomeByDate = host + "/incomes/date/"
    static let getCostByMonth = host + "/costs/"
    static let getWallets = host + "/wallets"
    static let getDataChart = host + "/total-in-out"
    
}
