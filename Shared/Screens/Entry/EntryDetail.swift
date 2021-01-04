//
// Created by Applichic on 12/29/20.
//

import SwiftUI
import os

struct EntryDetail: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var entry: Entry?
    var password: String = ""

    @State private var isHidden = true
    @State private var height: CGFloat = .zero
    @State private var isDeleteAlertOpen = false

    init(vaultData: VaultData, entry: Binding<Entry?>) {
        self._entry = entry

        if entry.wrappedValue != nil {
            do {
                let key = vaultData.password
                password = try Security.decryptData(key: key, data: entry.wrappedValue!.password!, reloadAes: false)
            } catch {
                password = ""
                let nsError = error as NSError
                let defaultLog = Logger()
                defaultLog.error("Error decrypting an entry password: \(nsError)")
            }
        }
    }

    var body: some View {
        #if os(iOS)
        return displayContent()
            .navigationBarTitleDisplayMode(.inline)
            .actionSheet(isPresented: $isDeleteAlertOpen) {
                ActionSheet(title: Text(entry!.name!), message: Text("are_you_sure_delete_entry"),
                        buttons: [
                            .destructive(Text("delete")) {
                                deleteEntry()
                            },
                            .cancel()
                        ]
                )
            }
        #else
        return displayContent()
            .alert(isPresented: $isDeleteAlertOpen) {() -> Alert in
                Alert(title: Text(entry!.name!), message: Text("are_you_sure_delete_entry"), primaryButton: .destructive(Text("delete")) {
                    deleteEntry()
                },
                      secondaryButton: .cancel(Text("cancel")))
                
                
            }
        #endif
    }
    
    private func displayContent() -> some View {
        Form {
            Section {
                Text(entry?.username ?? "")

                HStack {
                    GeometryReader { geometry in
                        #if os(iOS)
                        PasswordAttributed(text: password, width: geometry.size.width, dynamicHeight: $height) {
                            if !isHidden {
                                $0.attributedText = PasswordAttributed.colorizePassword(password: password, isSecure: false)
                            } else {
                                let hiddenPassword = password.replacingOccurrences(of: "[^\\s]", with: "*", options: .regularExpression)
                                let attributedPassword = NSMutableAttributedString.init(string: hiddenPassword)
                                $0.attributedText = attributedPassword
                            }
                        }.frame(minHeight: height)
                        #else
                        Text(password)
                        #endif
                    }
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .frame(minHeight: height + 16)

                    Button(action: { isHidden.toggle() }) {
                        Image(systemName: isHidden ? "eye.fill" : "eye.slash.fill")
                    }
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
            }

            Section(header: Text("category")) {
                Text(entry?.category?.name ?? "")
            }

            Section {
                Button(action: { isDeleteAlertOpen.toggle() }) {
                    HStack {
                        Spacer()
                        Text("delete").foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
                .navigationTitle(entry?.name ?? "")
    }

    private func deleteEntry() {
        withAnimation {
            viewContext.delete(entry!)

            do {
                try viewContext.save()
                entry = nil
                mode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                let defaultLog = Logger()
                defaultLog.error("Error deleting an entry: \(nsError)")
            }
        }
    }
}
