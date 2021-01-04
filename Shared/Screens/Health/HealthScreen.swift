//
// Created by Lazyos on 30/12/2020.
//

import SwiftUI

struct HealthScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Form {

            }
                    .navigationTitle("health")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: { mode.wrappedValue.dismiss() }) {
                                Label("", systemImage: "chevron.backward")
                            }
                        }
                    }
        }
    }
}
