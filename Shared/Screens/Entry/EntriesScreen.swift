//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI
import os

struct EntriesScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State private var isAddingEntry = false
    @State private var isShowingEntryDetail = false
    @State private var isDeleteAlertOpen = false
    @State private var entryToDelete: Entry? = nil
    @State private var currentEntry: Entry?
    @State private var searchText: String = ""

    var body: some View {
        #if os(iOS)
        return displayContent()
                .navigationBarTitleDisplayMode(.inline)
                .actionSheet(isPresented: $isDeleteAlertOpen) {
                    ActionSheet(title: Text(entryToDelete!.name!), message: Text("are_you_sure_delete_entry"),
                            buttons: [
                                .destructive(Text("delete")) {
                                    deleteEntry()
                                },
                                .cancel()
                            ]
                    )
                }
        #else
        return displayContent()
                .frame(width: .infinity, height: .infinity)
                .alert(isPresented: $isDeleteAlertOpen) { () -> Alert in
                    Alert(title: Text(entryToDelete!.name!), message: Text("are_you_sure_delete_entry"), primaryButton: .destructive(Text("delete")) {
                        deleteEntry()
                    },
                            secondaryButton: .cancel(Text("cancel")))


                }
        #endif
    }

    private func displayContent() -> some View {
        SearchNavigation(text: $searchText, search: {}, cancel: {}) {
            VStack {
                #if os(iOS)
                NavigationLink(destination: EntryDetail(vaultData: vaultData, entry: $currentEntry),
                        isActive: $isShowingEntryDetail) {
                    EmptyView()
                }
                #endif

                EntryListByVault(filterValue: vaultData.vault!.id!.uuidString, search: searchText,
                        onDelete: askDeleteEntry) { (entry: Entry) in
                    EntryItem(entry: entry)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentEntry = entry
                                isShowingEntryDetail.toggle()
                            }
                }
            }
                    .navigationTitle("passwords")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: { mode.wrappedValue.dismiss() }) {
                                Label("", systemImage: "chevron.backward")
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: { isAddingEntry.toggle() }) {
                                Label("", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $isAddingEntry) {
                        NavigationView {
                            NewEntryScreen(vaultData: vaultData)
                        }
                    }
        }
    }

    private func askDeleteEntry(entry: Entry) {
        self.entryToDelete = entry
        isDeleteAlertOpen.toggle()
    }

    private func deleteEntry() {
        withAnimation {
            viewContext.delete(entryToDelete!)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                let defaultLog = Logger()
                defaultLog.error("Error deleting an entry: \(nsError)")
            }
        }
    }
}
