//
//  Response.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

struct Response<Payload: Decodable>: Decodable {
    let payload: Payload
}
