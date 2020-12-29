//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct CategoriesScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Category.createdAt, ascending: true)],
            animation: .default)
    private var categories: FetchedResults<Category>

    var vaultData: VaultData
    @State private var isAddingCategory = false

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    CategoryItem(category: category)
                }
            }
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
        }
                .sheet(isPresented: $isAddingCategory) {
                    NavigationView {
                        NewCategoryScreen()
                    }
                }
    }
}
