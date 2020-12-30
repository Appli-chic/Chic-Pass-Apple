//
// Created by Lazyos on 30/12/2020.
//

import SwiftUI

struct EntryItem: View {
    var entry: Entry

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor(hex: entry.category!.color!)!))
                        .frame(width: 40, height: 40)

                Image(systemName: entry.category!.icon!)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.white)
                        .frame(width: 25, height: 25)
                        .padding(10)
            }

            VStack {
                HStack {
                    Text(entry.name!)
                            .font(.headline)

                    Spacer()
                }

                HStack {
                    Text(entry.username!)
                            .font(.caption)

                    Spacer()
                }
            }
        }.padding(4)
    }
}
