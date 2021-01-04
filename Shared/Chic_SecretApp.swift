//
//  Chic_SecretApp.swift
//  Shared
//
//  Created by Applichic on 12/28/20.
//

import SwiftUI

class VaultData: ObservableObject {
    @Published var isMainScreenActive = false
    @Published var vault: Vault? = nil
    @Published var password: String = ""
}

@main
struct Chic_SecretApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let persistenceController = PersistenceController.shared
    var vaultData = VaultData()

    var body: some Scene {
        WindowGroup {
            VaultsScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(vaultData)
        }
    }
}
