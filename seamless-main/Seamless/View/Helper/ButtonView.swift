//
//  Button.swift
//  Seamless
//
//  Created by Young Li on 10/29/23.
//

import SwiftUI

struct ButtonView: View {
    var text: String = ""
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(text)
              .font(
                .custom("Montserrat-Black", size: 16)
              )
              .kerning(1.8)
              .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 18)
        .frame(width: 280, alignment: .center)
        .background(Color(red: 0.05, green: 0.78, blue: 0.75))
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 4)
    }
}

#Preview {
    ButtonView(text: "default")
}
