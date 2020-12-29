//
//  ContentView.swift
//  Shared
//
//  Created by Applichic on 12/28/20.
//

import SwiftUI
import CoreData

struct VaultsScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Vault.createdAt, ascending: true)],
            animation: .default)
    private var vaults: FetchedResults<Vault>

    @State private var showingNewVaultScreen = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(vaults) { vault in
                        Text("Item at")
                    }
                }
                        .listStyle(InsetGroupedListStyle())
            }
                    .navigationBarTitle("vaults", displayMode: .large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showingNewVaultScreen.toggle() }) {
                                Label("Add vault", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $showingNewVaultScreen) {
                        NavigationView<NewVaultScreen> {
                            NewVaultScreen()
                        }
                    }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
