//
//  Account.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

struct Account: Decodable {
    let brokerAccountId: String
    let brokerAccountType: String
}

struct AccountsPayload: Decodable {
    let accounts: [Account]
}
