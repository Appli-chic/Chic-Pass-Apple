//
// Created by Applichic on 12/29/20.
//

import SwiftUI
import os

struct EntryDetail: View {
    @EnvironmentObject var vaultData: VaultData
    @Binding var entry: Entry

    @State var password: String = ""

    private func onInit() {
        do {
            let key = vaultData.password
            password = try Security.decryptData(key: key, data: entry.password!, reloadAes: false)
        } catch {
            password = ""
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error decrypting an entry password: \(nsError)")
        }
    }

    var body: some View {
        Form {
            Section {
                Text(entry.username ?? "")
                Text(password)
            }

            Section(header: Text("category")) {
                Text(entry.category?.name ?? "")
            }
        }
                .navigationTitle(entry.name ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    onInit()
                }
    }
}