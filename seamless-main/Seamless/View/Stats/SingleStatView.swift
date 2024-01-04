//
//  SingleStatView.swift
//  Seamless
//
//  Created by Young Li on 11/8/23.
//
//  Source: https://www.youtube.com/watch?v=nu74-aRobSs&t=261s

import SwiftUI
import Charts

// MARK: - Pie/Donut chart prepartaion
// Enumeration of interactive chart's
enum GraphType: String, CaseIterable{
    case pie = "Pie"
    case donut = "Donut"
}

struct statBasic: Identifiable {
    var id: UUID = .init()
    var context: String
    var value: Double
}

// MARK: - Data preparation
extension [statBasic] {
    func findData(_ on: String) -> Double? {
        if let data = self.first(where: {
            $0.context == on
        }) {
            return data.value
        }
        return nil
    }
    
    func index(_ on: String) -> Int {
        if let index = self.firstIndex(where: {
            $0.context == on
        }) {
            return index
        }
        
        return 0
    }
}

// MARK: - PopOver view showing specific data info
struct ChartPopOverView: View {
    var value: Double
    var context: String
    var isTitleView: Bool = false
    var isSelection: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) { // Center align the VStack
            let output = isTitleView && !isSelection ? "Highest" : context
            Text("\(output)")
                .font(.title3)
                .foregroundColor(Color.black.opacity(0.6))
                .multilineTextAlignment(.center) // Center align the text
            HStack(spacing: 4) {
                Text(String(value))
                    .font(.custom("Gluten-Bold", size: 17))
                    .foregroundColor(Color.black.opacity(0.8))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center) // Center align the text
            }
        }
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(Color.white.opacity(0.5))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .center) // Center align the frame
    }
}

// MARK: - Chart view
struct SingleStatView: View {
    // State and properties for chart customization
    @State private var isPieSelected: Bool = true
    @State private var barSelection: String?
    @State private var pieSelection: Double?
    @GestureState private var isDetectingLongPress = false
    @State private var dragOffset: CGSize = .zero
    @State private var gradientIndex: Int = 0
    @State private var displayTextIndex = 0
    
    // Binding for receiving data
    @Binding var dataList: [statBasic]
    var title: String
    
        
    // Gradient colors for chart background
    private let gradientColors: [[Color]] = [
        [Color.blue, Color.purple],
        [Color.green, Color.yellow],
        [Color.pink, Color.orange],
        [Color.teal, Color.red],
        [Color.indigo, Color.yellow],
        [Color.white]
    ]

    var body: some View {
        VStack {
            // Title
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.primary)
                .padding(.top, 5)
            
            
            // Add more engaging statistical analysis
            if !dataList.isEmpty {
                let totalValues = dataList.reduce(0) { $0 + $1.value }
                let averageValue = totalValues / Double(dataList.count)
                let maxValue = dataList.max(by: { $0.value < $1.value })?.value ?? 0
                let minValue = dataList.min(by: { $0.value < $1.value })?.value ?? 0
                
                let roundedAverage = round(averageValue)
                let statTexts: [String] = [
                    "User Engagement: \(Int(totalValues)) ❤️ interactions!",
                    "Explore the Excitement: \(String(format: "%.1f", roundedAverage)) ⭐️ out of 10",
                    "Maximum App Buzz: \(Int(maxValue)) 🚀",
                    "Minimum Buzz (Everyone's a Fan!): \(Int(minValue)) 👏"
                ]

                VStack {
                    // Display statistics with tap gesture for cycling through texts
                    Text(statTexts[displayTextIndex])
                        .font(.custom("Gluten-Bold", size: 14))
                        .foregroundColor(Color.black.opacity(0.8))
                        .padding(.vertical, 10)
                        .onTapGesture {
                            withAnimation {
                                displayTextIndex = (displayTextIndex + 1) % statTexts.count
                            }
                        }
                }
            }
            // Chart customization options
            HStack {
                Toggle("", isOn: $isPieSelected)
                    .toggleStyle(SwitchToggleStyle(tint: Color.gray))
                    .labelsHidden()

                Text(isPieSelected ? "Donut" : "Pie")
                    .font(.custom("Gluten-Bold", size: 16))
                    .foregroundColor(Color.black.opacity(0.8))
            }
            .padding(.horizontal, 30)
            // Chart
            Chart {
                ForEach(dataList.sorted(by: { $0.value > $1.value })) { data in
                    SectorMark(
                        angle: .value("#", data.value),
                        innerRadius: .ratio(isPieSelected ? 0.50 : 0),
                        angularInset: isPieSelected ? 6 : 1
                    )
                    .cornerRadius(8)
                    .foregroundStyle(by: .value("Data", data.context))
                    .opacity(barSelection == nil ? 1 : (barSelection == data.context ? 1 : 0.4))
                }
            }
            .chartAngleSelection(value: $pieSelection)
            .chartLegend(position: .bottom, alignment: .center, spacing: 25)
            .frame(height: 300)
            .padding(.top, 15)
            .animation(.easeInOut, value: isPieSelected)
            .gesture(
                // Gesture for navigating through gradient colors
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            dragOffset = value.translation
                        } else if value.translation.width > 0 {
                            dragOffset = CGSize(width: 0, height: 0)
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < 0 {
                            gradientIndex = (gradientIndex + 1) % gradientColors.count
                        } else if value.translation.width > 0 {
                            gradientIndex = (gradientIndex - 1 + gradientColors.count) % gradientColors.count
                        }
                        dragOffset = .zero
                    }
            )
            // Display details about the highest value
            if let highestNum = dataList.max(by: { $1.value > $0.value }) {
                if let barSelection, let selectedData = dataList.findData(barSelection) {
                    ChartPopOverView(value: selectedData, context: barSelection, isTitleView: true, isSelection: true)
                        .padding(.vertical)
                        .offset(x: 0, y: 0)
                } else {
                    ChartPopOverView(value: highestNum.value, context: "Highest Num", isTitleView: true)
                        .padding(.vertical)
                        .offset(x: 0, y: 0)
                }
            }
            
            
        }
        .background(
            // Background gradient for the chart
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors[gradientIndex]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(0.5)
        )
        .padding(.top, 5)
        .padding()
        .onChange(of: pieSelection, initial: false) { oldValue, newValue in
            // Detect and update bar selection based on pie chart selection
            if let newValue {
                findData(newValue, dataList)
            } else {
                barSelection = nil
            }
        }
        .frame(width: 370, height: 550)
    }
    
    
    // Function to find the corresponding bar for a given pie chart selection
    func findData(_ rangeValue: Double, _ dataList: [statBasic]) {
        var initialValue: Double = 0
        let convertedArray = dataList
            .sorted(by: {$0.value > $1.value})
            .compactMap { data -> (String, Range<Double>) in
                let rangeEnd = initialValue + data.value
                let tuple = (data.context, initialValue..<rangeEnd)
                initialValue = rangeEnd
                return tuple
            }
        if let data = convertedArray.first(where: {
            $0.1.contains(rangeValue)
        }) {
            barSelection = data.0
        }
    }
}

#Preview {
    SingleStatView(dataList: .constant([.init(context: "female", value: 1), .init(context: "male", value: 3)]), title: "Default")
}

