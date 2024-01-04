//
//  SurveyRow.swift
//  Seamless
//
//  Created by Young Li on 10/29/23.
//

import SwiftUI

struct SurveyRow: View {
    // State to track tap animation
    @State var survey: Survey
    @State private var isTapped: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Hospital Image
            Image("hospital")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            // Survey Details
            VStack(alignment: .leading, spacing: 4) {
                // Survey ID
                Text("Survey \(String(survey.surveyId.uuidString.prefix(8)))")
                    .font(.headline)
                    .foregroundColor(.black)
                    .bold()
                // Completed Date
                Text("Date: \(survey.completedDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.35, green: 0.83, blue: 0.91), lineWidth: 2)
            )
            .shadow(color: isTapped ? Color.blue.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
            .scaleEffect(isTapped ? 0.95 : 1.0)
            .onTapGesture {
                withAnimation {
                    isTapped.toggle()
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

#Preview {
    SurveyRow(survey: Survey())
}
