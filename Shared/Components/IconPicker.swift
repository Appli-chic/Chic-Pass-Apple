//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

class IconData: Identifiable, Equatable {
    var icon: String = ""

    init() {

    }

    init(icon: String) {
        self.icon = icon
    }

    static func ==(lhs: IconData, rhs: IconData) -> Bool {
        lhs.icon == rhs.icon
    }
}

private let iconList: [IconData] = [
    IconData(icon: "house.fill"),
    IconData(icon: "cart.fill"),
    IconData(icon: "creditcard.fill"),
    IconData(icon: "gamecontroller.fill"),
    IconData(icon: "tram.fill"),
    IconData(icon: "car.fill"),
    IconData(icon: "airplane"),
    IconData(icon: "envelope.fill"),
    IconData(icon: "bubble.left.and.bubble.right.fill"),
    IconData(icon: "iphone"),
    IconData(icon: "tv.fill"),
    IconData(icon: "heart.fill"),
    IconData(icon: "cross.case.fill"),
    IconData(icon: "pills.fill"),
    IconData(icon: "terminal.fill"),
    IconData(icon: "books.vertical.fill"),
    IconData(icon: "text.book.closed.fill"),
    IconData(icon: "graduationcap.fill"),
    IconData(icon: "network"),
    IconData(icon: "thermometer.sun.fill"),
    IconData(icon: "megaphone.fill"),
    IconData(icon: "case.fill"),
    IconData(icon: "puzzlepiece.fill"),
    IconData(icon: "building.columns.fill"),
    IconData(icon: "building.2.fill"),
    IconData(icon: "key.fill"),
    IconData(icon: "display"),
    IconData(icon: "wave.3.left.circle.fill"),
    IconData(icon: "music.note"),
    IconData(icon: "guitars.fill"),
    IconData(icon: "paintbrush.pointed.fill"),
    IconData(icon: "paintpalette.fill"),
    IconData(icon: "photo.on.rectangle.angled")
]

var previewIconList: [IconData] = [
    IconData(icon: "house.fill"),
    IconData(icon: "cart.fill"),
    IconData(icon: "creditcard.fill"),
    IconData(icon: "gamecontroller.fill"),
    IconData(icon: "tram.fill"),
    IconData(icon: "envelope.fill"),
    IconData(icon: "bubble.left.and.bubble.right.fill"),
    IconData(icon: "pills.fill"),
    IconData(icon: "books.vertical.fill"),
    IconData(icon: "graduationcap.fill"),
    IconData(icon: "case.fill"),
    IconData(icon: "music.note"),
]

struct IconPicker: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var isDisplayingModal = false
    @Binding var selectedIcon: IconData
    var color: Color

    let columns = [
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30)),
        GridItem(.adaptive(minimum: 30))
    ]


    var body: some View {
        ZStack {
            NavigationLink(destination: IconPickerScreen(selectedIcon: $selectedIcon),
                    isActive: $isDisplayingModal) {
                EmptyView()
            }

            HStack {
                LazyVGrid(
                        columns: columns,
                        spacing: 10
                ) {
                    ForEach(previewIconList) { item in
                        ZStack {
                            if item == selectedIcon {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(color)
                                        .frame(width: 35, height: 35)
                            }

                            Image(systemName: item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(item == selectedIcon ? Color.white : Color(UIColor.label))
                                    .frame(width: 25, height: 25)
                                    .padding(10)
                                    .onTapGesture {
                                        selectedIcon = item
                                    }
                        }
                    }
                }
                        .frame(maxWidth: .infinity)
                        .padding(.trailing)

                // Workaround to have the navigation and the keyboard dismissed on a tap on the background
                Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: 20, height: .infinity)
                        .onTapGesture {
                            isDisplayingModal.toggle()
                        }
            }
        }
    }
}

struct IconPickerScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var selectedIcon: IconData

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(iconList) { iconData in
                    Image(systemName: iconData.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24.0)
                            .padding(.all)
                            .onTapGesture {
                                selectedIcon = iconData

                                if previewIconList.firstIndex(of: iconData) == nil {
                                    previewIconList[0] = iconData
                                }

                                mode.wrappedValue.dismiss()
                            }
                }
            }
        }.allowAutoDismiss {
            false
        }
    }
}