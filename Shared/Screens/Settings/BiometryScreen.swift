//
// Created by Lazyos on 31/12/2020.
//

import SwiftUI

struct BiometryScreen: View {
    @State private var isBiometryActivated = false
    @State private var isShowingBiometryCheck = false

    var body: some View {
        Form {
            Section {
                Toggle(isOn: Binding(get: { isBiometryActivated }, set: { value in
                    if isBiometryActivated != value {
                        if value {
                            isShowingBiometryCheck.toggle()
                        } else {
                            isBiometryActivated = value
                            let preferences = UserDefaults.standard
                            preferences.setValue(false, forKey: biometryKey)
                            preferences.setValue("", forKey: biometryPasswordsKey)
                            preferences.synchronize()
                        }
                    }
                })) {
                    Text("biometry")
                }
            }
        }
                .navigationBarTitle("biometry")
                .sheet(isPresented: $isShowingBiometryCheck) {
                    NavigationView<BiometryCheckScreen> {
                        BiometryCheckScreen(onPasswordChecked: onPasswordChecked)
                    }
                }
    }

    private func onPasswordChecked(password: String) {
        isBiometryActivated = true

        let preferences = UserDefaults.standard
        preferences.setValue(true, forKey: biometryKey)
        preferences.setValue(password, forKey: biometryPasswordsKey)
        preferences.synchronize()
    }
}
