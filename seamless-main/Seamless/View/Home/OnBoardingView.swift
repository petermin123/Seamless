//
//  OnBoardingView.swift
//  Seamless
//
//  Created by Young Li on 11/4/23.
//
//  Source: https://www.youtube.com/watch?v=rCgbJf5SWQE&t=54s

import SwiftUI

struct OnBoardingView: View {
    // Stores the UserDefaults Bool as whether the onboardingView is shown or not
    @AppStorage("onboardingActive") var onboardingActive: Bool?
    @State private var isLinkActive = false
    @State private var shouldNavigate = false
    
    @State var offset: CGFloat = 0
    @State var survey: Survey
    
    var body: some View {
        // Custom Pager View
        OffsetPageTabView(offset: $offset) {
            HStack(spacing: 0) {
                ForEach(boardingScreens) { screen in
                    VStack(spacing: 15) {
                        Image(screen.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
                            .scaleEffect(getScreenBounds().height < 750 ? 0.9 : 1)
                            .offset(y: getScreenBounds().height < 750 ? -100 : -120)
                        
                        VStack(alignment: .center, spacing: 20){
                            Text(screen.title)
                                .font(.custom("Gluten-Bold", size: 48))
                            
                            Text(screen.description)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .offset(y: -70)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        
                    }
                    .padding()
                    .frame(width: getScreenBounds().width)
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(.white)
                // Size as image size
                .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
                .scaleEffect(2)
                .rotationEffect(.init(degrees: -25))
                .rotationEffect(.init(degrees: getRotation()))
                .offset(y: -getScreenBounds().width + 20)
            , alignment: .leading
        )
        .background(
            Color("color\(getIndex() + 1)")
                .animation(.easeInOut, value: getIndex())
        )
        .ignoresSafeArea(.container, edges: .all)
        // The animation of the background flow
        .overlay(
            VStack {
                // Bottom Content
                HStack {
                    Button {
                        onboardingActive = false
                        self.shouldNavigate = true
                    } label: {
                        ButtonView(text: "Start")
                    }
                    .navigationDestination(isPresented: $shouldNavigate) {
                        HomePageView(survey: survey)
                    }
                }
                
                // Indicators
                HStack {
                    Button {
                        offset = max(offset - getScreenBounds().width, 0)
                    } label: {
                        if offset == 0 {
                            Text("Prev")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .opacity(0.0)
                        } else {
                            Text("Prev")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(boardingScreens.indices, id: \.self) { index in
                            Circle()
                                .fill(.white)
                                .opacity(index == getIndex() ? 1 : 0.4)
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == (getIndex()) ? 1.3 : 0.85)
                                .animation(.easeInOut, value: getIndex())
                        }
                    }
                    
                    Spacer()
                    
                    // Setting mac offset
                    Button {
                        offset = min(offset + getScreenBounds().width, getScreenBounds().width * CGFloat(onboardingFactor))
                    } label: {
                        if offset == getScreenBounds().width * CGFloat(onboardingFactor) {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .opacity(0.0)
                        } else {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.top, 25)
                .padding(.horizontal, 8)
            }
            .padding()
            , alignment: .bottom
        )
    }
    
    // Getting rotation effect
    func getRotation() -> Double {
        let progress = offset / (getScreenBounds().width * 4)
        
        let rotation = Double(progress) * 360
        
        return rotation
    }
    
    // Changing background color based on offset
    func getIndex() -> Int {
        let progress = (offset / getScreenBounds().width).rounded()
        return Int(progress)
    }
}

#Preview {
    OnBoardingView(survey: Survey())
}

extension View {
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
