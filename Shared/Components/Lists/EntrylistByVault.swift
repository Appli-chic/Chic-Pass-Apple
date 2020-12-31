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
    let onDelete: (Entry) -> Void

    var body: some View {
        List {
            ForEach(fetchRequest.wrappedValue, id: \.id) { item in
                self.content(item)
            }
                    .onDelete(perform: { offsets in
                        let entry = offsets.map {
                            fetchRequest.wrappedValue[$0]
                        }.first.unsafelyUnwrapped
                        onDelete(entry)
                    })
        }
    }

    init(filterValue: String, search: String, onDelete: @escaping (Entry) -> Void,
         @ViewBuilder content: @escaping (T) -> Content) {
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
        self.onDelete = onDelete
    }
}