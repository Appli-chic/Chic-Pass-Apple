//
// Created by Applichic on 12/29/20.
//

import SwiftUI
import os

struct EntryDetail: View {
    @Binding var entry: Entry
    var password: String = ""

    @State private var isHidden = true
    @State private var height: CGFloat = .zero

    init(vaultData: VaultData, entry: Binding<Entry>) {
        self._entry = entry

        do {
            let key = vaultData.password
            password = try Security.decryptData(key: key, data: entry.wrappedValue.password!, reloadAes: false)
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

                HStack {
                    GeometryReader { geometry in
                        PasswordAttributed(text: password, width: geometry.size.width, dynamicHeight: $height) {
                            $0.attributedText = PasswordAttributed.colorizePassword(password: password, isSecure: false)
                        }.frame(minHeight: height)
                    }
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .frame(minHeight: height + 16)

                    Button(action: {}) {
                        Image(systemName: isHidden ? "eye.fill" : "eye.slash.fill")
                    }
                            .onTapGesture {
                                isHidden.toggle()
                            }
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
            }

            Section(header: Text("category")) {
                Text(entry.category?.name ?? "")
            }
        }
                .navigationTitle(entry.name ?? "")
                .navigationBarTitleDisplayMode(.inline)
    }
}
