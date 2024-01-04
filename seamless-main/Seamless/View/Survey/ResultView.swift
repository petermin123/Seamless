//
//  ResultView.swift
//  Seamless
//
//  Created by Young Li on 10/22/23.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var survey: Survey
    
    @State private var isButtonDisabled = false
    @State private var isRatingShown = false
    @State private var showRatingPrompt = false
    
    var vaccine: Vaccine
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 354, height: 314)
                  .background(Color(red: 0.91, green: 0.97, blue: 0.98))
                  .cornerRadius(18)
                
                ScrollView {
                    Text(congrats)
                      .font(
                        Font.custom("Gluten", size: 32)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                      .frame(width: 393, alignment: .top)
                      .padding(.bottom, 10)
                    
                    VStack {
                        Text("Survey completed\n")
                        Text("Here is our recommendation:\n")
                        if vaccine.name != "Next" {
                            VStack {
                                Text("Take \(vaccine.name)")
                                Text("Dosing: \(vaccine.instruction)")
                            }
                                .font(
                                    .custom("Montserrat-Regular", size: 16)
                                )
                                .foregroundColor(.red)
                        } else {
                            Text("\(vaccine.instruction)")
                        }
                        
                    }
                    .font(
                      .custom("Montserrat-Regular", size: 24)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                    .frame(width: 312, height: 239, alignment: .top)
                }
                .padding()
            }
            .frame(height: 314)
            .padding(.bottom, 20)
                        
            VStack {
                NavigationLink {
                    QRCodeView(surveyId: survey.surveyId)
                } label: {
                    ButtonView(text: qrcodeStr)
                        .padding()
                }
                
                NavigationLink {
                    HomePageView(survey: Survey())
                } label: {
                    ButtonView(text: homeStr)
                        .padding()
                }
                
            }
        }
        // Pop-up alert for asking whether the user would like to do a rating
        .alert(isPresented: $showRatingPrompt) {
            Alert(
                title: Text("Would you like to do a rating?"),
                primaryButton: .cancel(Text("No")) {
                    showRatingPrompt = false
                }, secondaryButton: .default(Text("Yes")){
                    isRatingShown = true
                    showRatingPrompt = false
                })
        }
        .sheet(isPresented: $isRatingShown) {
            RatingView(isRatingShown: $isRatingShown)
                .presentationDetents([.medium, .large])
        }
        .navigationBarBackButtonHidden(true)
        // Save the finished survey
        .onAppear {
            showRatingPrompt = true
            survey.result = vaccine
            survey.status = .Completed
            let date = Date.now
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            survey.completedDate = dateFormatter.string(from: date)
            print("\(survey.questionList) + \(survey.result.name) + \(survey.status) + \(survey.completedDate)")
            if modelData.add(survey) {
                print("Add the survey!")
                pushNotify()
                addSurveyToFirestore(to: "surveys", from: survey)
            } else {
                print("Fail to add the survey!")
            }
        }
    }
}

#Preview {
    ResultView(survey: .constant(Survey()), vaccine: defaultVaccine)
        .environmentObject(ModelData())
}
