//
// Created by Applichic on 12/29/20.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content()
                        .disabled(isShowing)
                        .blur(radius: isShowing ? 2 : 0)

                if isShowing {
                    Rectangle()
                            .fill(Color(UIColor.systemBackground)).opacity(isShowing ? 0.6 : 0)
                            .edgesIgnoringSafeArea(.all)

                    ProgressView()
                            .scaleEffect(2.0, anchor: .center)
                            .frame(width: 100, height: 100)
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color.primary)
                            .cornerRadius(12)
                }
            }
        }
    }
}