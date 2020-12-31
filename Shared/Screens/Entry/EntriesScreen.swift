//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct EntriesScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State var isAddingEntry = false
    @State var isShowingEntryDetail = false
    @State var currentEntry = Entry()
    @State private var searchText: String = ""

    var body: some View {
        SearchNavigation(text: $searchText, search: search, cancel: cancel) {
            VStack {
                NavigationLink(destination: EntryDetail(vaultData: vaultData, entry: $currentEntry), isActive: $isShowingEntryDetail) {
                    EmptyView()
                }

                EntryListByVault(filterValue: vaultData.vault!.id!.uuidString, search: searchText) { (entry: Entry) in
                    EntryItem(entry: entry)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentEntry = entry
                                isShowingEntryDetail.toggle()
                            }
                }
                        .listStyle(PlainListStyle())
                        .resignKeyboardOnDragGesture()
            }
                    .navigationBarTitle("passwords")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { mode.wrappedValue.dismiss() }) {
                                Label("", systemImage: "chevron.backward")
                            }
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
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

    func search() {
    }

    func cancel() {
    }
}