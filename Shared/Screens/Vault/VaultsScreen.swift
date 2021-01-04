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
            
            #if os(iOS)
            displayContent()
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
            #else
            displayContent()
                .alert(isPresented: $isDeleteAlertOpen) {() -> Alert in
                    Alert(title: Text(""), message: Text("are_you_sure_delete_vault"), primaryButton: .destructive(Text("delete")) {
                        deleteVault(offsets: offsets!)
                    },
                          secondaryButton: .cancel(Text("cancel")))
                    
                    
                }
            #endif

            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                NavigationLink(destination: MainScreen(),
                        isActive: $vaultData.isMainScreenActive) {
                    EmptyView()
                }
            }
            #endif
        }
    }
    
    private func displayContent() -> some View {
        ZStack {

            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationLink(destination: MainScreen(),
                        isActive: $vaultData.isMainScreenActive) {
                    EmptyView()
                }
            }
            #endif

            displayingVaults()
        }
                .navigationTitle("vaults")
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        #if os(macOS)
                        Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left")
                        })
                        #endif
                    }

                    ToolbarItem(placement: .confirmationAction) {
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

    private func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }

    private func displayingVaults() -> some View {
        #if os(iOS)
        return displayVaultList()
            .listStyle(InsetGroupedListStyle())
        #else
        return displayVaultList()
            .listStyle(SidebarListStyle())
        #endif
    }
    
    private func displayVaultList() -> some View {
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
