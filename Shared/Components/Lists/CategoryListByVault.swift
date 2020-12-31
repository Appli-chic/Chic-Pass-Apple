//
// Created by Lazyos on 30/12/2020.
//

import SwiftUI
import CoreData

struct CategoryListByVault<T: Category, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var items: FetchedResults<T> {
        fetchRequest.wrappedValue
    }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content
    let onDelete: (Category) -> Void

    var body: some View {
        List {
            ForEach(fetchRequest.wrappedValue) { item in
                self.content(item)
            }
                    .onDelete(perform: { offsets in
                        let category = offsets.map {
                            fetchRequest.wrappedValue[$0]
                        }.first.unsafelyUnwrapped
                        onDelete(category)
                    })
        }
    }

    init(filterValue: String, search: String, onDelete: @escaping (Category) -> Void,
         @ViewBuilder content: @escaping (T) -> Content) {
        var predicate = NSPredicate(format: "vault.id == %@", filterValue)

        if !search.isEmpty {
            predicate = NSPredicate(format: "vault.id == %@ and name contains[cd] %@", filterValue, search.lowercased())
        }

        fetchRequest = FetchRequest<T>(
                entity: T.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Category.createdAt, ascending: true)],
                predicate: predicate
        )
        self.content = content
        self.onDelete = onDelete
    }
}
