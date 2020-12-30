//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct EntriesScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)],
            animation: .default)
    private var entries: FetchedResults<Entry>

    @State var isAddingEntry = false
    @State var isShowingEntryDetail = false
    @State var currentEntry = Entry()
    @State private var searchText: String = ""

    var body: some View {
        SearchNavigation(text: $searchText, search: search, cancel: cancel) {
            VStack {
                NavigationLink(destination: EntryDetail(entry: $currentEntry), isActive: $isShowingEntryDetail) {
                    EmptyView()
                }

                List {
                    ForEach(entries) { entry in
                        EntryItem(entry: entry)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    currentEntry = entry
                                    isShowingEntryDetail.toggle()
                                }
                                .sheet(isPresented: $isAddingEntry) {
                                    NavigationView {
                                        NewEntryScreen()
                                    }
                                }
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
        }
    }

    func search() {
    }

    func cancel() {
    }
}