//
//  ModelData.swift
//  Seamless
//
//  Created by Young Li on 10/21/23.
//

import Foundation
import Combine

final class ModelData: NSObject, ObservableObject, URLSessionDataDelegate {
    
    // MARK: - Local Storage
    static let shared = ModelData()
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private let surveyURL = DocumentsDirectory.appendingPathComponent("seamlessSurvey.json")
    private let questionURL = DocumentsDirectory.appendingPathComponent("seamlessQuestion.json")
    private let vaccinationURL = DocumentsDirectory.appendingPathComponent("seamlessVaccine.json")
    private let bundleQuestionURL = Bundle.main.url(forResource: "Question", withExtension: "json")
    private let bundleVaccineURL = Bundle.main.url(forResource: "Vaccine", withExtension: "json")
    
    // MARK: - Published variables
    @Published var surveyList: [Survey] = []
    @Published var questionList: [Question] = [defaultQuestion]
    @Published var vaccineList: [Vaccine] = [defaultVaccine]
    @Published var ratingList: [Double] = []
    @Published var feedbackList: [String] = []
    @Published var ratingStatList: [statBasic] = []
    @Published var PDFUrl: URL?
    @Published var showShareSheet: Bool = false
    
    // MARK: - Rating statistics methods
    func updateRatingFeedbackLists(rating: [Double], feedback: [String]) {
        ratingList.removeAll()
        feedbackList.removeAll()
        ratingList = rating
        print("Modeldata: \(ratingList)")
        feedbackList = feedback
        print("Modeldata: \(feedbackList)")
    }
    
    func updateRatingStatList() {
        ratingStatList.removeAll()
        for idx in 0...4 {
            ratingStatList.append(.init(context: ratingContext[idx], value: ratingList[idx]))
        }
        print(ratingStatList)
    }
    
    // MARK: - Basic CRUD operations on surveys
    func add(_ newSurvey: Survey) -> Bool {
        var flag = true
        for survey in surveyList {
            if survey.surveyId == newSurvey.surveyId{
                flag = false
                return flag
            }
        }
        if flag {
            self.surveyList.append(newSurvey)
            return flag
        }
    }
    
    func update(_ updatedSurvey: Survey) -> Bool {
        var flag = false
        for index in 0..<surveyList.count{
            if surveyList[index].surveyId == updatedSurvey.surveyId{
                flag = true
                self.surveyList.remove(at: index)
                self.surveyList.insert(updatedSurvey, at: index)
                return flag
            }
        }
        if !flag {
            self.surveyList.append(updatedSurvey)
        }
        return flag
    }
    
    func delete(_ surveyId: UUID) -> Bool{
        var flag = false
        for index in 0..<surveyList.count{
            if surveyList[index].surveyId == surveyId{
                self.surveyList.remove(at: index)
                flag = true
                return flag
            }
        }
        return flag
    }
    
    func find(_ surveyId: UUID) -> Survey? {
        var found: Survey?
        for index in 0..<surveyList.count{
            if surveyList[index].surveyId == surveyId{
                found = surveyList[index]
            }
        }
        return found ?? nil
    }
    
    func list() -> String {
        var outputString = ""
        for (index, survey) in surveyList.enumerated(){
            outputString = outputString + "\(index+1). \(survey.description)\n\n"
        }
        return outputString
    }
    
    // MARK: - Local Storage methods
    func loadJSON(_ url: URL, _ type: String) -> Bool {
        let decoder = JSONDecoder()
        var surveys = [Survey]()
        var questions = [Question]()
        var vaccines = [Vaccine]()
        let tempData: Data
        
        do {
            tempData = try Data(contentsOf: url)
        } catch let error as NSError {
            print(error)
            return false
        }
        switch type {
        case "Vaccine":
            if let decoded = try? decoder.decode([Vaccine].self, from: tempData) {
                vaccines = decoded
                self.vaccineList = vaccines
                return true
            }
        case "Question":
            if let decoded = try? decoder.decode([Question].self, from: tempData) {
                questions = decoded
                self.questionList = questions
                return true
            }
        case "Survey":
            if let decoded = try? decoder.decode([Survey].self, from: tempData) {
                surveys = decoded
                self.surveyList = surveys
                return true
            }
        default:
            print("Error")
        }
        
        // String(data: tempData, encoding: .utf8)
        return false
    }
    
    func saveJSON() -> Bool {
        var outputDataSurvey = Data(), outputDataQuestion = Data(), outputDataVaccine = Data()
        let encoder = JSONEncoder()
        if let encodedSurvey = try? encoder.encode(self.surveyList),
        let encodedQuestion = try? encoder.encode(self.questionList),
        let encodedVaccine = try? encoder.encode(self.vaccineList){
            outputDataSurvey = encodedSurvey
            outputDataQuestion = encodedQuestion
            outputDataVaccine = encodedVaccine
            do {
                try outputDataSurvey.write(to: surveyURL)
                try outputDataQuestion.write(to: questionURL)
                try outputDataVaccine.write(to: vaccinationURL)
            } catch let error as NSError {
                print (error)
                return false
            }
            return true
        }
        else { return false }
    }
    
    func checkBundle() {
        if filemgr.fileExists(atPath: surveyURL.path) {
            // load the existing file
            if loadJSON(surveyURL, "Survey") {
                print("Survey original!")
            } else {
                print("Error Survey original!")
            }
        } else {
            selfDisk()
            print("Clear the disk!")
        }
        
        if filemgr.fileExists(atPath: questionURL.path) {
            // load the existing file
            if loadJSON(questionURL, "Question") {
                print("Question original!")
            } else {
                print("Error Question original!")
            }
        } else {
            if loadJSON(bundleQuestionURL!, "Question") {
                print("Question bundle original!")
            } else {
                print("Error Question bundle original!")
            }
        }
        
        if filemgr.fileExists(atPath: vaccinationURL.path) {
            // load the existing file
            if loadJSON(vaccinationURL, "Vaccine") {
                print("Vaccine original!")
            } else {
                print("Error Vaccine original!")
            }
        } else {
            if loadJSON(bundleVaccineURL!, "Vaccine") {
                print("Vaccine bundle original!")
            } else {
                print("Error Vaccine bundle original!")
            }
        }
        
        if !saveJSON() {
            print("Error save bundle original!")
        } else {
            print("Save bundle original!")
        }
        
    }
    
    func selfDisk() {
        self.surveyList.removeAll()
        self.questionList.removeAll()
        self.questionList.append(defaultQuestion)
        self.vaccineList.removeAll()
        self.vaccineList.append(defaultVaccine)
    }
    
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           return formatter
       }()
}

// MARK: - Survey list sorting methods
extension ModelData {
    // Function to sort surveys by completedDate in ascending order
    func sortSurveysByDateAscending() {
        surveyList.sort { (survey1, survey2) in
            if let date1 = dateFormatter.date(from: survey1.completedDate),
               let date2 = dateFormatter.date(from: survey2.completedDate) {
                return date1.compare(date2) == .orderedAscending
            } else {
                return false
            }
        }
    }

    // Function to sort surveys by completedDate in descending order
    func sortSurveysByDateDescending() {
        surveyList.sort { (survey1, survey2) in
            if let date1 = dateFormatter.date(from: survey1.completedDate),
               let date2 = dateFormatter.date(from: survey2.completedDate) {
                return date1.compare(date2) == .orderedDescending
            } else {
                return false
            }
        }
    }
    
    func calculateCompletionRate(surveys: [Survey]) -> Int {
        let completedSurveys = surveys.filter { $0.status == .Completed }
        let completionRate = (Double(completedSurveys.count) / Double(surveys.count)) * 100
        return Int(completionRate)
    }
}


