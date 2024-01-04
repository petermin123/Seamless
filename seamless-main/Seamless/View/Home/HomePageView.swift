//
//  HomePageView.swift
//  Seamless
//
//  Created by Young Li on 10/29/23.
//

import SwiftUI

struct HomePageView: View {
    @State var survey: Survey
    
    var body: some View {
        VStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 502, height: 502)
              .background(
                Image("HomePage")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 502, height: 502)
                  .clipped()
              )
              .cornerRadius(502)
              .shadow(color: .black.opacity(0.11), radius: 1.69643, x: 0, y: 3.39286)
            
            Text(appName)
              .font(
                .custom("Gluten-Bold", size: 67)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
              .frame(width: 393, alignment: .top)
            
            Text(appDescription)
              .font(.custom("Montserrat-Regular", size: 16))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
              .frame(width: 298, height: 70, alignment: .top)
              .padding(.bottom, 30)
            
            // Buttons link to the next view
            NavigationLink {
                QuestionView(survey: $survey, content: ["Question": 1])
            } label: {
                ButtonView(text: startSurvey)
                    .padding(.bottom, 10)
            }
            
            NavigationLink {
                SurveyListView()
            } label: {
                ButtonView(text: listSurvey)
                    .padding(.bottom, 10)
            }
            
            NavigationLink {
                HelpView()
            } label: {
                ButtonView(text: helpStr)
                    .padding(.bottom, 10)
            }
            
            NavigationLink {
                StatsView()
            } label: {
                ButtonView(text: statStr)
                    .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .offset(y: -120)
    }
}

#Preview {
    HomePageView(survey: Survey())
}
