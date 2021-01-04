//
// Created by Applichic on 12/29/20.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

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
                    displayLoadingBackground()

                    displayLoading()
                }
            }
        }
    }
    
    private func displayLoadingBackground() -> some View {
        #if os(macOS)
        return Rectangle()
            .fill(Color(NSColor.windowBackgroundColor)).opacity(isShowing ? 0.6 : 0)
        #else
        return Rectangle()
                .fill(Color(UIColor.systemBackground)).opacity(isShowing ? 0.6 : 0)
                .edgesIgnoringSafeArea(.all)
        #endif
    }
    
    private func displayLoading() -> some View {
        #if os(macOS)
        return ProgressView()
            .scaleEffect(2.0, anchor: .center)
            .frame(width: 100, height: 100)
            .background(Color(NSColor.controlBackgroundColor))
            .foregroundColor(Color.primary)
            .cornerRadius(12)
        #else
        return ProgressView()
            .scaleEffect(2.0, anchor: .center)
            .frame(width: 100, height: 100)
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(Color.primary)
            .cornerRadius(12)
        #endif
    }
}
