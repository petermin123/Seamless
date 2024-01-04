//
//  Vaccine.swift
//  Seamless
//
//  Created by Young Li on 10/21/23.
//

import Foundation
import UIKit

// Create Class for Vaccine
class Vaccine: CustomStringConvertible, Codable, Identifiable {
    
    var id: Int
    var name: String
    var instruction: String
    
    init(id: Int, name: String, instruction: String) {
        self.id = id
        self.name = name
        self.instruction = instruction
    }
    
    var description: String {
        return "\(self.name)."
    }
}
