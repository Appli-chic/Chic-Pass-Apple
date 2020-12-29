//
//  VaultItem.swift
//  Chic Secret
//
//  Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct VaultItem: View {
    var vault: Vault

    var body: some View {
        HStack {
            Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32.0)
            Text(vault.name ?? vault.name!)
                    .font(.headline)
                    .padding(.leading)
            Spacer()
        }
                .padding(.vertical, 16)
    }
}
