//
//  QuestionView.swift
//  Seamless
//
//  Created by Young Li on 10/22/23.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var survey: Survey
    var content: [String: Int]
    @State var question: Question = defaultQuestion
    @State var text: String = ""
    @State var choice: [String] = []
    @State var followUp: [[String: Int]] = [[:]]
    @State var flag: Bool = true
    
    var body: some View {
        VStack {
            if flag {
                ZStack {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 354, height: 314)
                      .background(Color(red: 0.91, green: 0.97, blue: 0.98))
                      .cornerRadius(18)
                    
                    Text(text)
                      .font(
                        .custom("Montserrat-Black", size: 24)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                      .frame(width: 312, height: 100, alignment: .top)
                }
                .padding(.bottom, 20)
                
                // Link the follow-up question / vaccine with the choice
                ForEach(choice, id: \.self) { single in
                    let index = choice.firstIndex(of: single) ?? 0
                    let nextQuestion = followUp[index]
                    NavigationLink {
                        QuestionView(survey: $survey, content: nextQuestion)
                    } label: {
                        ButtonView(text: single)
                            .padding()
                    }
                }
            } else {
                VaccineView(survey: $survey, content: content)
            }
        }
        .navigationBarBackButtonHidden(true)
        // Based on the given context, decide whether to show the question or vaccine result
        .onAppear {
            for key in content.keys {
                switch key {
                case _ where key.hasPrefix("Question"):
                    let index = Int((content[key] ?? 1) - 1)
                    let getVal = modelData.questionList[index]
                    question = getVal
                    text = getVal.questionText
                    choice = getVal.choice
                    followUp = getVal.followUpQuestions
                    survey.questionList.append(question)
                    flag = true
                case _ where key.hasPrefix("Vaccine"):
                    flag = false
                default:
                    flag = false
                }
            }
        }
    }
}

#Preview {
    QuestionView(survey: .constant(Survey()), content: ["Question": 1])
        .environmentObject(ModelData())
}
