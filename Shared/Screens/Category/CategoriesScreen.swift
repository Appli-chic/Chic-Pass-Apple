//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI
import os
import CoreData

struct CategoriesScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State private var isAddingCategory = false
    @State private var isDeleteAlertOpen = false
    @State private var isShowingErrorDelete = false
    @State private var categoryToDelete: Category? = nil
    @State private var searchText: String = ""

    var body: some View {
        #if os(iOS)
        return displayContent()
                .actionSheet(isPresented: $isDeleteAlertOpen) {
                    ActionSheet(title: Text(categoryToDelete!.name!), message: Text("are_you_sure_delete_category"),
                            buttons: [
                                .destructive(Text("delete")) {
                                    checkCanDeleteCategory()
                                },
                                .cancel()
                            ]
                    )
                }
        #else
        return displayContent()
                .frame(width: .infinity, height: .infinity)
                .alert(isPresented: $isDeleteAlertOpen) { () -> Alert in
                    Alert(title: Text(categoryToDelete!.name!), message: Text("are_you_sure_delete_category"), primaryButton: .destructive(Text("delete")) {
                        checkCanDeleteCategory()
                    },
                            secondaryButton: .cancel(Text("cancel")))


                }
        #endif
    }

    private func displayContent() -> some View {
        SearchNavigation(text: $searchText, search: {}, cancel: {}) {
            CategoryListByVault(filterValue: vaultData.vault!.id!.uuidString, search: searchText,
                    onDelete: askDeleteCategory) { (category: Category) in
                CategoryItem(category: category)
            }
                    .listStyle(PlainListStyle())
                    .navigationTitle("categories")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: { mode.wrappedValue.dismiss() }) {
                                Label("", systemImage: "chevron.backward")
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
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
                .alert(isPresented: $isShowingErrorDelete) {
                    Alert(title: Text("warning"), message: Text("cant_delete_category"),
                            dismissButton: .default(Text("ok")))
                }
    }

    private func askDeleteCategory(category: Category) {
        self.categoryToDelete = category
        isDeleteAlertOpen.toggle()
    }

    private func checkCanDeleteCategory() {
        do {
            let fetchRequest = NSFetchRequest<Entry>()
            fetchRequest.entity = Entry.entity()
            fetchRequest.predicate = NSPredicate(format: "category.id == %@", categoryToDelete!.id!.uuidString)
            let entries = try viewContext.fetch(fetchRequest)

            if !entries.isEmpty {
                isShowingErrorDelete.toggle()
            } else {
                deleteCategory()
            }
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error retrieving entries: \(nsError)")
            isShowingErrorDelete.toggle()
        }
    }

    private func deleteCategory() {
        withAnimation {
            viewContext.delete(categoryToDelete!)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                let defaultLog = Logger()
                defaultLog.error("Error deleting an category: \(nsError)")
            }
        }
    }
}
