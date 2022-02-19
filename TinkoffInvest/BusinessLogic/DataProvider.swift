//
//  DataProvider.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Foundation
import Combine

protocol DataProvider {
    func fetchAccounts() -> AnyPublisher<[Account], Never>
    func fetchOperations(forAccountWithId: String) -> AnyPublisher<[Operation], Never>
}

final class DataProviderImpl {
    private let session: URLSession
    
    // MARK: - Lifecycle
    init() {
        self.session = URLSession(configuration: .default)
    }
}

extension DataProviderImpl: DataProvider {
    func fetchAccounts() -> AnyPublisher<[Account], Never> {
        session.dataTaskPublisher(for: API.accounts.urlRequest)
            .map { $0.data }
            .decode(type: Response<AccountsPayload>.self, decoder: JSONDecoder())
            .map { $0.payload.accounts }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    func fetchOperations(forAccountWithId id: String) -> AnyPublisher<[Operation], Never> {
        session.dataTaskPublisher(for: API.operations(accountId: id).urlRequest)
            .map { $0.data }
            .decode(type: Response<OperationsPayload>.self, decoder: JSONDecoder())
            .map { $0.payload.operations }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
