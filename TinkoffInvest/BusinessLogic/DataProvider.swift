//
//  DataProvider.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation
import Combine

protocol DataProvider {
    func fetchAccounts() -> AnyPublisher<[Account], Error>
    func fetchOperations(forAccountWithId: String) -> AnyPublisher<[Operation], Error>
}

final class DataProviderImpl {
    private let session: URLSession
    
    // MARK: - Lifecycle
    init() {
        self.session = URLSession(configuration: .default)
    }
}

extension DataProviderImpl: DataProvider {
    func fetchAccounts() -> AnyPublisher<[Account], Error> {
        session.dataTaskPublisher(for: API.accounts.urlRequest)
            .map { $0.data }
            .decode(type: AccountsPayload.self, decoder: JSONDecoder())
            .map { $0.accounts }
            .eraseToAnyPublisher()
    }
    func fetchOperations(forAccountWithId id: String) -> AnyPublisher<[Operation], Error> {
        session.dataTaskPublisher(for: API.operations(accountId: id).urlRequest)
            .map { $0.data }
            .decode(type: OperationsPayload.self, decoder: JSONDecoder())
            .map { $0.operations }
            .eraseToAnyPublisher()
    }
}
