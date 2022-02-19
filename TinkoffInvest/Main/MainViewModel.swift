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
            .flatMap { [weak self] () ->  AnyPublisher<[Account], Never> in
                guard let self = self else { return Just([Account]()).eraseToAnyPublisher() }
                return self.dataProvider.fetchAccounts()
            }
            .flatMap { [weak self] accounts -> AnyPublisher<[CommissionSummary], Never> in
                guard let self = self else { return Just([CommissionSummary]()).eraseToAnyPublisher() }
                return Publishers.MergeMany(
                    accounts
                        .map { account in
                            self.dataProvider.fetchOperations(forAccountWithId: account.brokerAccountId)
                                .map { CommissionSummary(accountType: account.brokerAccountType, operations: $0) }
                        }
                )
                    .collect()
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .assign(to: \.commissionSummary, on: self)
            .store(in: &cancellables)
    }
}
