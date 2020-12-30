//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct CategoriesScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Category.createdAt, ascending: true)],
            animation: .default)
    private var categories: FetchedResults<Category>

    @State private var isAddingCategory = false
    @State private var searchText: String = ""

    var body: some View {
        SearchNavigation(text: $searchText, search: search, cancel: cancel) {
            CategoryListByVault(filterValue: vaultData.vault!.id!.uuidString) { (category: Category) in
                CategoryItem(category: category)
            }
                    .listStyle(PlainListStyle())
                    .resignKeyboardOnDragGesture()
                    .navigationBarTitle("categories")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { mode.wrappedValue.dismiss() }) {
                                Label("", systemImage: "chevron.backward")
                            }
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { isAddingCategory.toggle() }) {
                                Label("", systemImage: "plus")
                            }
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
        }
                .sheet(isPresented: $isAddingCategory) {
                    NavigationView {
                        NewCategoryScreen()
                    }
                }
    }

    func search() {
    }

    func cancel() {
    }
}
