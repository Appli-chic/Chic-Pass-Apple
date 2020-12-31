//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct CategoryItem: View {
    var category: Category

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: category.color!))
                        .frame(width: 40, height: 40)

                Image(systemName: category.icon!)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.white)
                        .frame(width: 25, height: 25)
                        .padding(10)
            }

            Text(category.name!)
                    .font(.headline)
        }.padding(4)
    }
}
