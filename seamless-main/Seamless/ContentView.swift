//
//  ContentView.swift
//  Seamless
//
//  Created by Young Li on 10/21/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @AppStorage("onboardingActive") var onboardingActive: Bool = true
    
    // Monitor scene phase to see if the app is inactive; if so, we'll save our model to disk.
    @Environment(\.scenePhase) private var scenePhase
    
    // Function to perform when app is inactive (defined by parent)
    let saveTasks: () -> Void
    
    var body: some View {
        NavigationView {
            // If the onboarding is active (first-time user), show the onboarding view
            if onboardingActive {
                OnBoardingView(survey: Survey())
            } 
            // Else show the homepage view
            else {
                HomePageView(survey: Survey())
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // Whenever the app becomes inactive, save data to persistent storage
            if newPhase == .inactive { saveTasks() }
        }
    }
}

#Preview {
    ContentView(saveTasks: {})
        .environmentObject(ModelData())
}
