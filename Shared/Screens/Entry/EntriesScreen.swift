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

    var body: some View {
        NavigationView {
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
}