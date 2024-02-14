//
//  MainViewModel.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    // MARK: - Input
    let update = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    @Published private(set) var commissionSummary = [CommissionSummary]()
    @Published private(set) var error: Error?
    @Published var isErrorAlertPresented = false
    
    private let dataProvider: DataProvider
    private lazy var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        bindInput()
    }
}

private extension MainViewModel {
    func bindInput() {
        update
            .flatMap { [weak self] () ->  AnyPublisher<[Account], Error> in
                guard let self = self else {
                    return Just([Account]())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.dataProvider.fetchAccounts()
            }
            .flatMap { [weak self] accounts -> AnyPublisher<[CommissionSummary], Error> in
                guard let self = self else {
                    return Just([CommissionSummary]())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return Publishers.MergeMany(
                    accounts
                        .map { account in
                            self.dataProvider.fetchOperations(forAccountWithId: account.id)
                                .map { CommissionSummary(accountName: account.name, operations: $0) }
                        }
                )
                    .collect()
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.error = error
                default:
                    break
                }
            } receiveValue: { [weak self] summary in
                self?.commissionSummary = summary
            }
            .store(in: &cancellables)
    }
}
