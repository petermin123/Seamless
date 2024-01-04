//
//  Survey.swift
//  Seamless
//
//  Created by Young Li on 10/21/23.
//

import Foundation
import UIKit

// Enumeration of Status
enum Status: String, Codable, CaseIterable, Identifiable{
    case Completed = "Completed"
    case Incomplete = "Incomplete"
    case Other = "Other" // Patient may provide future reference
    
    var id: String { rawValue }
}

// Create Class for Survey
class Survey: CustomStringConvertible, Codable, Identifiable{
    
    var surveyId: UUID
    var questionList: [Question]
    var result: Vaccine
    var status: Status
    var completedDate: String
    var note: String

    var description: String {
        return "Survey \(self.surveyId) is \(self.status) at \(self.completedDate)"
    }
    
    init() {
        self.surveyId = UUID()
        self.questionList = []
        self.result = defaultVaccine
        self.status = .Incomplete
        self.completedDate = ""
        self.note = ""
    }
    
    init(note: String) {
        self.surveyId = UUID()
        self.questionList = []
        self.result = defaultVaccine
        self.status = .Incomplete
        self.completedDate = ""
        self.note = note
    }
}
