//
//  Watermark.swift
//  SnowSeeker
//
//  Created by EO on 06/10/21.
//

import SwiftUI

//challenge 1
struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.black.opacity(0.5))
                .accessibility(hidden: true)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}
