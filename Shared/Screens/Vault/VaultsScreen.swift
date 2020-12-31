//
//  ContentView.swift
//  Shared
//
//  Created by Applichic on 12/28/20.
//

import SwiftUI
import CoreData
import os

struct VaultsScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var vaultData: VaultData

    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Vault.createdAt, ascending: true)],
            animation: .default)
    private var vaults: FetchedResults<Vault>

    @State private var showingNewVaultScreen = false
    @State private var isShowingPasswordInput = false
    @State private var isDeleteAlertOpen = false
    @State private var offsets: IndexSet? = nil
    @State private var currentVault: Vault = Vault()

    var body: some View {
        NavigationView {
            VStack {

                NavigationLink(destination: MainScreen(),
                        isActive: $vaultData.isMainScreenActive) {
                    EmptyView()
                }

                List {
                    ForEach(vaults) { vault in
                        VaultItem(vault: vault)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    currentVault = vault
                                    isShowingPasswordInput.toggle()
                                }
                                .sheet(isPresented: $isShowingPasswordInput) {
                                    NavigationView<PasswordUnlockScreen> {
                                        PasswordUnlockScreen(vault: $currentVault)
                                    }
                                }
                    }
                            .onDelete(perform: askDeleteVault)
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
                    .actionSheet(isPresented: $isDeleteAlertOpen) {
                        ActionSheet(title: Text(""), message: Text("are_you_sure_delete_vault"),
                                buttons: [
                                    .destructive(Text("delete")) {
                                        deleteVault(offsets: offsets!)
                                    },
                                    .cancel()
                                ]
                        )
                    }
        }
    }

    private func askDeleteVault(offsets: IndexSet) {
        self.offsets = offsets
        isDeleteAlertOpen.toggle()
    }

    private func deleteVault(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                vaults[$0]
            }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                let defaultLog = Logger()
                defaultLog.error("Error deleting a vault: \(nsError)")
            }
        }
    }
}
