//
//  ContentView.swift
//  TinkoffInvest
//
//  Created by Артур Чернов on 19.02.2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel
    
    // MARK: - Lifecycle
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Размер коммиссий за операции:")
                .font(.title)
                .padding(.bottom)
            if !viewModel.commissionSummary.isEmpty {
                ForEach(viewModel.commissionSummary) { commissionSummary in
                    VStack(alignment: .leading) {
                        Text(commissionSummary.accountName)
                            .font(.body)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        Text(commissionSummary.commissionSummary)
                            .font(.body)
                    }
                }
                .padding(.bottom)
            } else {
                Text("Загрузка...")
                    .padding(.bottom)
            }
            Button(action: viewModel.update.send) {
                Text("Обновить")
                    .fontWeight(.semibold)
            }
        }
        .alert("Ошибка", isPresented: $viewModel.isErrorAlertPresented) {
            Button("OK") {
                viewModel.isErrorAlertPresented = false
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Неизвестная ошибка")
        }
        .onAppear(perform: viewModel.update.send)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(dataProvider: DataProviderImpl()))
    }
}
