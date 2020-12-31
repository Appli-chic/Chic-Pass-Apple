//
// Created by Lazyos on 31/12/2020.
//

import SwiftUI
import CoreData

struct CategoryListInNewEntry<T: Category, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var items: FetchedResults<T> {
        fetchRequest.wrappedValue
    }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        ForEach(fetchRequest.wrappedValue, id: \.id) { item in
            self.content(item)
        }
    }

    init(filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(
                entity: T.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Category.createdAt, ascending: true)],
                predicate: NSPredicate(format: "vault.id == %@", filterValue)
        )
        self.content = content
    }
}
