//
// Created by Applichic on 12/30/20.
//

import SwiftUI
import CoreData

struct EntryListByVault<T: Entry, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var items: FetchedResults<T> {
        fetchRequest.wrappedValue
    }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { item in
            self.content(item)
        }
    }

    init(filterValue: String, search: String, @ViewBuilder content: @escaping (T) -> Content) {
        var predicate = NSPredicate(format: "vault.id == %@", filterValue)

        if !search.isEmpty {
            predicate = NSPredicate(format: """
                                            vault.id == %@ 
                                            and (
                                            name contains[cd] %@ or username contains[cd] %@ or category.name contains[cd] %@
                                            )
                                            """,
                    filterValue, search.lowercased(), search.lowercased(), search.lowercased())
        }

        fetchRequest = FetchRequest<T>(
                entity: Entry.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)],
                predicate: predicate
        )
        self.content = content
    }
}