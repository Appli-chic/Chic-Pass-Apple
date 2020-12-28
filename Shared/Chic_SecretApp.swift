//
//  Chic_SecretApp.swift
//  Shared
//
//  Created by Applichic on 12/28/20.
//

import SwiftUI

@main
struct Chic_SecretApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            VaultsScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
