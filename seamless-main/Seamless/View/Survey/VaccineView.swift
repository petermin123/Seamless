//
//  VaccineView.swift
//  Seamless
//
//  Created by Young Li on 10/28/23.
//

import SwiftUI

struct VaccineView: View {
    @EnvironmentObject var modelData: ModelData
    
    @Binding var survey: Survey
    var content: [String: Int]
    @State private var stringDisplay = vaccineChoice
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 354, height: 314)
                  .background(Color(red: 0.91, green: 0.97, blue: 0.98))
                  .cornerRadius(18)
                
                Text(stringDisplay)
                  .font(
                    .custom("Montserrat-Black", size: 24)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                  .frame(width: 312, height: 100, alignment: .top)
            }
            .padding(.bottom, 20)
            
            // Based on vaccine result, show the list
            ForEach(content.keys.sorted(), id: \.self) { key in
                let index = Int((content[key] ?? 1) - 1)
                let vaccine = modelData.vaccineList[index]
                NavigationLink {
                    ResultView(survey: $survey, vaccine: vaccine)
                } label: {
                    ButtonView(text: vaccine.name)
                        .padding()
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            if content.values.first == 1 {
                stringDisplay = "No vaccination needed. Please click 'Next'."
            } else if content.values.first == 2 {
                stringDisplay = "Please consult hepatology and click 'Next'."
            }
        })
    }
}

#Preview {
    VaccineView(survey: .constant(Survey()), content: ["Vaccine": 1])
        .environmentObject(ModelData())
}
