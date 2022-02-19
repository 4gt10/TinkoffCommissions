//
//  Operation.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

struct Operation: Decodable {
    enum Status: String, Decodable {
        case done = "Done"
        case decline = "Decline"
        case progress = "Progress"
    }
    let status: Status
    let operationType: String
    let payment: Double
    let currency: String
    
    var isCommission: Bool {
        ["BrokerCommission", "ExchangeCommission", "ServiceCommission", "MarginCommission"].contains(operationType)
    }
    var isCompleted: Bool {
        return status == .done
    }
}

struct OperationsPayload: Decodable {
    let operations: [Operation]
}
