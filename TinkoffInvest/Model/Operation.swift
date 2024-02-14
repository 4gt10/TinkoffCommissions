//
//  Operation.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

struct Operation: Decodable {
    struct Payment: Decodable {
        let nano: Int
        let currency: String
        let units: String
    }
    
    let operationType: String
    let payment: Payment
    
    var isCommission: Bool {
        operationType.contains("FEE")
    }
}

struct OperationsPayload: Decodable {
    let operations: [Operation]
}
