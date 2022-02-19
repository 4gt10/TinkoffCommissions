//
//  CommissionSummary.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

struct CommissionSummary {
    let accountType: String
    let commissionSummary: String
    
    init(accountType: String, operations: [Operation]) {
        self.accountType = accountType
        let commissions = operations.filter { $0.isCommission && $0.isCompleted }
        let currencies = Set(commissions.map { $0.currency })
        var commissionSummary = ""
        currencies.forEach { currency in
            let sum = commissions.filter { $0.currency == currency }.reduce(0.0) { $0 + $1.payment }
            commissionSummary += "\(String(format: "%.2f", abs(sum))) \(currency)\n"
        }
        self.commissionSummary = commissionSummary
    }
}

extension CommissionSummary: Identifiable {
    var id: String { accountType }
}
