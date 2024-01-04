//
//  RatingStatsView.swift
//  Seamless
//
//  Created by Young Li on 11/8/23.
//

import SwiftUI

struct RatingStatsView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var isShown: Bool
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                // Segment Picker for Chart and Feedback
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("Chart")
                        .tag(0)
                        .font(.headline)
                        .padding()
                        .foregroundColor(selectedTab == 0 ? .white : .accentColor)
                        .background(selectedTab == 0 ? Color.accentColor : Color.clear)
                        .cornerRadius(10)

                    Text("Feedback")
                        .tag(1)
                        .font(.headline)
                        .padding()
                        .foregroundColor(selectedTab == 1 ? .white : .accentColor)
                        .background(selectedTab == 1 ? Color.accentColor : Color.clear)
                        .cornerRadius(10)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Display Chart or Feedback based on selected tab
                if selectedTab == 0 {
                    ScrollView {
                        SingleStatView(dataList: $modelData.ratingStatList, title: "")
                    }
                    .padding(.horizontal)
                } else {
                    List {
                        ForEach(modelData.feedbackList, id: \.self) { feedback in
                            FeedbackRowView(text: feedback)
                        }
                    }
                }
            }
            .navigationTitle("Rating")
            .navigationBarItems(trailing: Button {
                isShown = false
            } label: {
                // Return Button
                Label("Return", systemImage: "chevron.left")
                    .labelStyle(.titleOnly)
            }
            )
        }
        .onAppear {
            getRatingsForAnalysis(from: "ratings")
        }
    }
}


#Preview {
    RatingStatsView(isShown: .constant(true))
        .environmentObject(ModelData())
}
