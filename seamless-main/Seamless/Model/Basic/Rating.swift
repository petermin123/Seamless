//
//  Rating.swift
//  Seamless
//
//  Created by Young Li on 11/5/23.
//

import Foundation
import UIKit

// Create Class for Rating
struct Rating: CustomStringConvertible, Codable, Identifiable {
    
    var id: UUID
    var rating: Int
    var feedback: String
    
    var description: String {
        return "Rating: \(self.rating) - \(self.feedback)"
    }
    
    init(rating: Int, feedback: String) {
        self.id = UUID()
        self.rating = rating
        self.feedback = feedback
    }
}
