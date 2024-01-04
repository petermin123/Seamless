//
//  FeedbackRowView.swift
//  Seamless
//
//  Created by Young Li on 11/8/23.
//

import SwiftUI

struct FeedbackRowView: View {
    var text: String
    @State private var isZoomed: Bool = false

    var body: some View {
        // Display feedback text with zoom-in effect on long press
        Text(text)
            .font(.custom("Montserrat", size: isZoomed ? 20 : 16))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.green.opacity(0.3))
                    .shadow(radius: 3)
            )
            .scaleEffect(isZoomed ? 1.1 : 1)
            .onLongPressGesture {
                withAnimation {
                    // Toggle zoom-in effect on long press
                    isZoomed.toggle()
                }
            }
    }
}

#Preview {
    FeedbackRowView(text: "default")
}
