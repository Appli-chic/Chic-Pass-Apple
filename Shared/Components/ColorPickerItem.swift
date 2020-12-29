//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

struct ColorPickerItem: View {
    @Binding var color: Color

    let colors = [
        Color.blue,
        Color.red,
        Color.green,
        Color.orange,
        Color.pink,
        Color.purple,
        Color.yellow,
        Color.black
    ]

    let columns = [
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30))
    ]

    var body: some View {
        HStack {
            LazyVGrid(
                    columns: columns,
                    spacing: 10
            ) {
                ForEach(colors, id: \.self) { item in
                    ZStack {
                        Circle()
                                .fill(item)
                                .frame(width: 25, height: 25)
                                .padding(10)
                                .onTapGesture {
                                    color = item
                                }

                        if (item == color) {
                            Circle()
                                    .stroke(item, lineWidth: 3)
                                    .frame(width: 35, height: 35)
                        }
                    }
                }
            }
                    .frame(maxWidth: .infinity)
                    .padding(4)

            ColorPicker("", selection: $color, supportsOpacity: false)
                    .frame(width: 40)
        }
    }
}