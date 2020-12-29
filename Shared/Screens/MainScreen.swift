//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var vaultData: VaultData
    @State private var currentTab = 1

    var body: some View {
        TabView(selection: $currentTab) {
//            EntriesScreen()
//                    .tag(1)
//                    .tabItem {
//                        Image(systemName: "list.star")
//                        Text("passwords")
//                    }
//                    .navigationBarTitle("")
//                    .navigationBarHidden(true)
//
//            CategoriesScreen(vaultData: vaultData)
//                    .tag(2)
//                    .tabItem {
//                        Image(systemName: "folder.fill")
//                        Text("categories")
//                    }
//                    .navigationBarTitle("")
//                    .navigationBarHidden(true)

            EmptyView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("profile")
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

            EmptyView()
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

    private func getTitle() -> String {
        switch currentTab {
        case 1:
            return NSLocalizedString("passwords", comment: "passwords")
        case 2:
            return NSLocalizedString("categories", comment: "categories")
        case 3:
            return NSLocalizedString("profile", comment: "profile")
        case 4:
            return NSLocalizedString("settings", comment: "settings")
        default:
            return NSLocalizedString("passwords", comment: "passwords")
        }
    }
}