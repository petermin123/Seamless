//
//  Question.swift
//  Seamless
//
//  Created by Young Li on 10/21/23.
//

import Foundation
import UIKit

// Create Class for Question
class Question: CustomStringConvertible, Codable, Identifiable{
    
    var id: Int
    var questionText: String
    var choice: [String]
    var answer: String
    var followUpQuestions: [[String: Int]]

    var description: String {
        return "The question is \(self.questionText)."
    }
    
    init(id: Int, questionText: String, choice: [String], answer: String, followUpQuestions: [[String: Int]]) {
        self.id = id
        self.questionText = questionText
        self.choice = choice
        self.answer = answer
        self.followUpQuestions = followUpQuestions
    }
}
