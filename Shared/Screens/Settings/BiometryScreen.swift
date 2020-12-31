//
// Created by Lazyos on 31/12/2020.
//

import SwiftUI

struct BiometryScreen: View {
    @EnvironmentObject var vaultData: VaultData

    @State private var isBiometryActivated = false
    @State private var isShowingBiometryCheck = false

    func getBiometryFromPreference() {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: biometryPasswordsKey) != nil {
            let dictionary = preferences.dictionary(forKey: biometryPasswordsKey)

            if dictionary != nil {
                if dictionary!.index(forKey: vaultData.vault!.id!.uuidString) != nil {
                    isBiometryActivated = true
                }
            }
        }
    }

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

                            if preferences.dictionary(forKey: biometryPasswordsKey) != nil {
                                var data = preferences.dictionary(forKey: biometryPasswordsKey)! as! [String: String]
                                data[vaultData.vault!.id!.uuidString] = nil
                                preferences.synchronize()
                            }
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
                .onAppear {
                    getBiometryFromPreference()
                }
    }

    private func onPasswordChecked(password: String) {
        isBiometryActivated = true

        let preferences = UserDefaults.standard
        var data = [String: String]()

        if preferences.dictionary(forKey: biometryPasswordsKey) != nil {
            data = preferences.dictionary(forKey: biometryPasswordsKey)! as! [String: String]
        }

        data[vaultData.vault!.id!.uuidString] = password
        preferences.setValue(data, forKey: biometryPasswordsKey)
        preferences.synchronize()
    }
}
