//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var vaultData: VaultData
    @State private var currentTab = 1

    var body: some View {
        #if os(macOS)
        displayTabView()
        #else
        displayTabView()
                .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
    
    private func displayTabView() -> some View {
        TabView(selection: $currentTab) {
            displayEntries()

            displayCategories()

            displayHealth()

            displaySettings()
        }
    }
    
    private func displayEntries() -> some View {
        #if os(macOS)
        return EntriesScreen()
                .tag(1)
                .tabItem {
                    Image(systemName: "list.star")
                    Text("passwords")
                }
        #else
        return EntriesScreen()
                .tag(1)
                .tabItem {
                    Image(systemName: "list.star")
                    Text("passwords")
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        #endif
    }
    
    private func displayCategories() -> some View {
        #if os(macOS)
        return CategoriesScreen()
                .tag(2)
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("categories")
                }
        #else
        return CategoriesScreen()
                .tag(2)
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("categories")
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        #endif
    }
    
    private func displayHealth() -> some View {
        #if os(macOS)
        return HealthScreen()
                .tag(3)
                .tabItem {
                    Image(systemName: "staroflife.fill")
                    Text("health")
                }
        #else
        return HealthScreen()
                .tag(3)
                .tabItem {
                    Image(systemName: "staroflife.fill")
                    Text("health")
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        #endif
    }
    
    private func displaySettings() -> some View {
        #if os(macOS)
        return SettingsScreen()
                .tag(4)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("settings")
                }
        #else
        return SettingsScreen()
                .tag(4)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("settings")
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        #endif
    }
}
