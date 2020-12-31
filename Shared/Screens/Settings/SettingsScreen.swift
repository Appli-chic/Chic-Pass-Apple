//
// Created by Lazyos on 30/12/2020.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: EmptyView()) {
                        Text("login_signup")
                    }
                }

                Section {
                    NavigationLink(destination: BiometryScreen()) {
                        Text("biometry")
                    }
                }
            }
                    .navigationBarTitle("settings")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { mode.wrappedValue.dismiss() }) {
                                Label("", systemImage: "chevron.backward")
                            }
                        }
                    }
        }
    }
}