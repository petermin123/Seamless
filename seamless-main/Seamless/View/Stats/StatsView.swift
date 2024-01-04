//
//  StatsView.swift
//  Seamless
//
//  Created by Young Li on 11/8/23.
//

import SwiftUI

struct StatsView: View {
    // State to control the presentation of RatingStatsView
    @State private var showRatingStats: Bool = false
    
    var body: some View {
        VStack {
            // Header Text
            Text(statStr)
                .font(
                    Font.custom("Gluten", size: 32)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                .frame(width: 208, alignment: .top)
                .padding(.top, 20)
            // Stats Container
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color(red: 0.91, green: 0.97, blue: 0.98))
                    .frame(width: 354, height: 693)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    .rotation3DEffect(
                        .degrees(10),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .scaleEffect(0.9) // Adjust the scale factor as needed
                    .padding(.horizontal)

                // Button to show RatingStatsView
                VStack {
                    Button {
                        withAnimation {
                            showRatingStats.toggle()
                        }
                    } label: {
                        Text(ratingStat)
                            .font(
                                Font.custom("Montserrat", size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            )
                    }
                    .sheet(isPresented: $showRatingStats) {
                        // Present RatingStatsView as a sheet
                        RatingStatsView(isShown: $showRatingStats)
                    }
                }
                .frame(width: 302, height: 603, alignment: .topLeading)
                .offset(y: 10)
                
        
            }
        }
    }
}



#Preview {
    StatsView()
}
