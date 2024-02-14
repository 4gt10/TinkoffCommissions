//
//  CommissionSummary.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

struct CommissionSummary {
    let accountName: String
    let commissionSummary: String
    
    private static let formatter = NumberFormatter()
    
    init(accountName: String, operations: [Operation]) {
        self.accountName = accountName
        let commissions = operations.filter { $0.isCommission }
        let currencies = Set(commissions.map { $0.payment.currency })
        var commissionSummary = ""
        currencies.forEach { currency in
            let sum = commissions
                .filter { $0.payment.currency == currency }
                .reduce(0.0) {
                    let value = Self.formatter.number(from: $1.payment.units)?.doubleValue ?? 0
                    return $0 + value
                }
            commissionSummary += "\(Self.currencySymbol(with: currency.capitalized)): \(String(format: "%.2f", abs(sum)))\n"
        }
        self.commissionSummary = commissionSummary
    }
}

private extension CommissionSummary {
    private static func currencySymbol(with code: String) -> String {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencyCode, value: code)?.capitalized ?? ""
    }
}

extension CommissionSummary: Identifiable {
    var id: String { accountName }
}
