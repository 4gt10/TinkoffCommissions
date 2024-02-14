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
        case post = "POST"
    }
    
    case accounts
    case operations(accountId: String)
    
    var baseURL: URL {
        let base = "https://invest-public-api.tinkoff.ru/rest/tinkoff.public.invest.api.contract.v1"
        switch self {
        case .accounts:
            return URL(string: "\(base).UsersService/")!
        case .operations:
            return URL(string: "\(base).OperationsService/")!
        }
        
    }
    
    var path: String {
        switch self {
        case .accounts: return "GetAccounts"
        case .operations: return "GetOperations"
        }
    }
    
    var method: Method {
        switch self {
        case .accounts, .operations:
            return .post
        }
    }
    
    var headers: [String: String] {
        var headers: [String: String] = [
            "Authorization": "Bearer *your Tinkoff Open API token here*"
        ]
        switch self {
        case .accounts, .operations:
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "application/json"
        }
        return headers
    }
    
    var parameters: [String: Any] {
        switch self {
        case .accounts:
            return [:]
        case let .operations(accountId):
            return [
                "accountId": accountId,
                "from": Date(timeIntervalSince1970: 0).ISO8601Format(),
                "to": Date().ISO8601Format(),
                "state": "OPERATION_STATE_EXECUTED"
            ]
        }
    }
    
    var urlRequest: URLRequest {
        func getUrl() -> URL {
            var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
            switch method {
            case .get:
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1 as? String) }
            case .post:
                break
            }
            return urlComponents.url!
        }
        
        func getHttpBody() -> Data? {
            switch method {
            case .get:
                return nil
            case .post:
                return try? JSONSerialization.data(withJSONObject: parameters)
            }
        }
        
        var urlRequest = URLRequest(url: getUrl())
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = getHttpBody()
        
        return urlRequest
    }
}
