//
//  RatingView.swift
//  Seamless
//
//  Created by Young Li on 11/5/23.
//
//  Source: https://www.youtube.com/watch?v=QFVMd3fMDfA

import SwiftUI

//  MARK: - Create the sliding board for point changing
struct MyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0, y: 0.5 * height))
        path.addCurve(to: CGPoint(x: 0.01522 * width, y: 0.26261 * height), control1: CGPoint(x: 0, y: 0.37048 * height), control2: CGPoint(x: 0.00677 * width, y: 0.26486 * height))
        path.addLine(to: CGPoint(x: 0.9674 * width, y: 0.00869 * height))
        path.addCurve(to: CGPoint(x: width, y: 0.5 * height), control1: CGPoint(x: 0.98531 * width, y: 0.00392 * height), control2: CGPoint(x: width, y: 0.22528 * height))
        path.addLine(to: CGPoint(x: width, y: 0.5 * height))
        path.addCurve(to: CGPoint(x: 0.9674 * width, y: 0.99131 * height), control1: CGPoint(x: width, y: 0.77473 * height), control2: CGPoint(x: 0.98531 * width, y: 0.99608 * height))
        path.addLine(to: CGPoint(x: 0.01522 * width, y: 0.73739 * height))
        path.addCurve(to: CGPoint(x: 0, y: 0.5 * height), control1: CGPoint(x: 0.00677 * width, y: 0.73514 * height), control2: CGPoint(x: 0, y: 0.62952 * height))
        path.addLine(to: CGPoint(x: 0, y: 0.5 * height))
        path.closeSubpath()
        
        return path
    }
}

//  MARK: - Basic Rating View Struct including emojis and feedbacks
struct RatingView: View {
    @State private var rating = 1
    @State private var feedback = ""
    @Binding var isRatingShown: Bool
    
    @State private var dragOffset: CGFloat = 0.0
    @State private var initialDragOffset: CGFloat = 0.0
    
    private let sliderWidth: CGFloat = 220.0
    private let circleSpacing: CGFloat = 44.0

    struct EmojiSection {
        let emoji: String
        let description: String
        let range: ClosedRange<Double>
        let rate: Int
    }
    
    // Enumeration for all emoji selections
    private let sections: [EmojiSection] = [
        EmojiSection(emoji: "🤬", description: "Angry", range: 0...0.2, rate: 1),
        EmojiSection(emoji: "😡", description: "Bad", range: 0.2...0.45, rate: 2),
        EmojiSection(emoji: "☺️", description: "Good", range: 0.45...0.7, rate: 3),
        EmojiSection(emoji: "🥰", description: "Love it", range: 0.7...0.93, rate: 4),
        EmojiSection(emoji: "🤩", description: "Heavenly", range: 0.93...1, rate: 5)
    ]
    
    var body: some View {
        let progress = dragOffset / sliderWidth
        let currentSection = sections.first(where: { $0.range.contains(Double(progress)) }) ?? sections.last
        NavigationView {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 354, height: 314)
                  .background(Color(red: 0.91, green: 0.97, blue: 0.98))
                  .cornerRadius(18)
                
                VStack (alignment: .leading) {
                    HStack {
                        Text("Rate your experience").bold().font(.title3)
                        Text(currentSection?.description ?? "")
                            .font(.system(size: 15))
                    }
                    HStack {
                        Text(currentSection?.emoji ?? "")
                            .font(.system(size: 40)).transition(.scale)
                            .animation(.easeOut(duration: 0.3), value: currentSection?.emoji)
                        ZStack (alignment: .leading) {
                            MyShape().frame(width: 230, height: 15)
                                .foregroundColor(.gray)
                            MyShape().frame(width: dragOffset + 10, height: 15)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("color1"), Color("color2"), Color("color3")]), startPoint: .leading, endPoint: .trailing))
                            HStack (spacing: circleSpacing) {
                                ForEach(0..<sections.count, id: \.self) { index in
                                    Circle().frame(width: 6 + CGFloat(index) * 1, height: 6 + CGFloat(index) * 1)
                                        .foregroundColor(.white)
                                }
                            }
                            .offset(x: 5)
                            Circle().frame(width: 30, height: 30)
                                .offset(x: dragOffset)
                                .foregroundColor(.white).shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            let change = value.translation.width
                                            let newValue = min(max(initialDragOffset + change, 0), self.sliderWidth - 15)
                                            self.dragOffset = newValue
                                        })
                                        .onEnded({ value in
                                            self.initialDragOffset = dragOffset
                                        })
                                )
                                .onAppear {
                                    self.initialDragOffset = dragOffset
                                }
                        }
                    }
                    HStack {
                        Text("Feedback: ").bold()
                        TextEditor(text: $feedback)
                            .frame(height: 100)
                    }
                }
                .frame(width: 320, height: 80)
                .padding()
            }
            .navigationTitle("Rating")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        isRatingShown = false
                    } label: {
                        Label("Cancel", systemImage: "chevron.left")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        rating = currentSection?.rate ?? 1
                        let finalRate = Rating(rating: rating, feedback: feedback)
                        addRatingToFirestore(to: "ratings", from: finalRate)
                        isRatingShown = false
                    } label: {
                        Label(title: {Text("Upload")}, icon: { Image(systemName: "square.and.arrow.up") })
                    }
                }
            }
        }
    }
}

#Preview {
    RatingView(isRatingShown: .constant(true))
}
