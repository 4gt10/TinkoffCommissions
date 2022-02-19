//
//  TinkoffInvestApp.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import SwiftUI

@main
struct TinkoffInvestApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(dataProvider: DataProviderImpl()))
        }
    }
}
