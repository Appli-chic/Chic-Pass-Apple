//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var vaultData: VaultData
    @State private var currentTab = 1

    var body: some View {
        TabView(selection: $currentTab) {
            EntriesScreen()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "list.star")
                        Text("passwords")
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

            CategoriesScreen()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "folder.fill")
                        Text("categories")
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

            HealthScreen()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "staroflife.fill")
                        Text("health")
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

            SettingsScreen()
                    .tag(4)
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("settings")
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
        }
                .navigationBarTitle("")
                .navigationBarHidden(true)
    }
}