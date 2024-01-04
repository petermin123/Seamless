//
//  Boarding.swift
//  Seamless
//
//  Created by Young Li on 11/4/23.
//

import Foundation
import SwiftUI

// MARK: - Boarding screen struct
struct BoardingScreen: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
    var color: Color
}

let title = appName
let color1 = Color(red: 193 / 255, green: 255 / 255, blue: 193 / 255)
let color2 = Color(red: 151.0 / 255, green: 255.0 / 255, blue: 255.0 / 255)
let color3 = Color(red: 230.0 / 255, green: 230.0 / 255, blue: 250.0 / 255)

var boardingScreens: [BoardingScreen] = [
    BoardingScreen(image: "vaccine", title: title, description: appDescription, color: color1),
    BoardingScreen(image: "survey", title: title, description: helpInstructionPartI, color: color2),
    BoardingScreen(image: "organ", title: title, description: helpInstructionPartII, color: color3)
]
let onboardingFactor = boardingScreens.count - 1
