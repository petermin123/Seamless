//
//  HelpView.swift
//  Seamless
//
//  Created by Young Li on 10/22/23.
//
import SwiftUI


struct HelpView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            HStack {
                Text(helpStr)
                    .font(
                        Font.custom("Gluten", size: 32)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                    .frame(width: 208, alignment: .top)

            }

            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 354, height: 600)
                    .background(Color(red: 0.91, green: 0.97, blue: 0.98))
                    .cornerRadius(18)

                Text(helpInstruction)
                    .font(
                        Font.custom("Montserrat", size: 20)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                    .frame(width: 302, height: 550, alignment: .topLeading)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage))
        }
        
        // Alert messages for feedback control
        HStack {
            Button(action: {
                showAlert = true
                alertMessage = "Thanks for your approval"
            }) {
                Text("👍🏻")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .padding(3)
            }

            Button(action: {
                showAlert = true
                alertMessage = "We will continue to improve"
            }) {
                Text("👎🏻")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .padding(3)
            }
        }
    }
}

#Preview {
    HelpView()
}
