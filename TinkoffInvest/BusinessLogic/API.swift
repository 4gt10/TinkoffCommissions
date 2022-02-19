//
//  API.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation

enum API {
    enum Method: String {
        case get = "GET"
    }
    
    case accounts
    case operations(accountId: String)
    
    var baseURL: URL {
        .init(string: "https://api-invest.tinkoff.ru/openapi/")!
    }
    
    var path: String {
        switch self {
        case .accounts: return "user/accounts"
        case .operations: return "operations"
        }
    }
    
    var method: Method {
        switch self {
        case .accounts, .operations:
            return .get
        }
    }
    
    var headers: [String: String] {
        var headers: [String: String] = [
            "Authorization": "Bearer *your Tinkoff Open API token here*"
        ]
        switch self {
        case .accounts, .operations:
            headers["Accept"] = "application/json"
        }
        return headers
    }
    
    var parameters: [String: Any] {
        switch self {
        case .accounts:
            return [:]
        case let .operations(accountId):
            return [
                "brokerAccountId": accountId,
                "from": Date(timeIntervalSince1970: 0).ISO8601Format(),
                "to": Date().ISO8601Format()
            ]
        }
    }
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        switch method {
        case .get:
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1 as? String) }
        }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
