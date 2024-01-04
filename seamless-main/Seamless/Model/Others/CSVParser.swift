//
//  CSVParser.swift
//
//  Created by Richard Telford on 6/4/23.
//
//  Modified by Young Li on 11/9/23.

import UIKit

//  MARK: - List initialization
var questionList: [Question] = []
var vaccineList: [Vaccine] = []

enum RowState {
    case begin
    case middle
    case end
    }

//  MARK: - Basic CSV Parser
func parseCSV() {
    let filePath = Bundle.main.url(forResource: "Seamless", withExtension: "csv")
    var rawDataString = ""
    var errorString: String?
    var columnNames = [Substring]()
    var infoArray = [[String:Any]]()
    
    // Split new line as needed
    do {
        rawDataString = try String(contentsOf: filePath!, encoding: .utf8)
    } catch let error as NSError {
        errorString = error.description
        print(errorString ?? "error")
    }
    let rows = rawDataString.split { $0.isNewline }
    
    var rowNumber = 0
    var rowString = ""
    while rowNumber < rows.count {
        rowString = String(rows[rowNumber])
        // Store property classification
        if rowNumber == 0 {
            columnNames = rowString.split(separator: ",", maxSplits: 50, omittingEmptySubsequences: false)
        }
        // Process each data
        else {
            var rowDict = [String:Any]()
            let info = processRow(rowString)
            var zz = 0
            for key in columnNames {
                // Pay specific attention to choice and followUpQuestions properties
                if key == "choice" {
                    let choices = handleChoice(info[zz])
                    rowDict[String(key)] = choices
                    zz += 1
                } else if key == "followUpQuestions" {
                    let followUpQuestions = handleFollowUpQuestions(info[zz])
                    rowDict[String(key)] = followUpQuestions
                    zz += 1
                }
                else {
                    rowDict[String(key)] = info[zz]
                    zz += 1
                }
            }
            infoArray.append(rowDict)
        }
        rowNumber = rowNumber + 1
    }
    let mixJSON = infoArray.toJSONString()
    print(mixJSON)
    loadMixedJSON(mixJSON)
}

//  MARK: - Basic Single Data Processor
func processRow(_ rowString:String) -> [String] {
    var rowState:RowState = .begin
    var dataFields = [String]()
    var dataField = ""
    for char in rowString {
        if char == "\"" {
            switch rowState {
            case .begin:
                rowState = .middle
            case .middle:
                rowState = .end
                dataFields.append(dataField)
                dataField = ""
            case .end:
                continue
            }
        } else if char == "," && rowState == .end {
            rowState = .begin
        }
        else {
            dataField.append(char)
        }
    }
    return dataFields
}

//  MARK: - Handle specific properties
func handleChoice(_ choiceField: String) -> [String] {
    var choices: [String] = []
    let withWhiteSpaceChoices = choiceField.split(separator: ";")
    for choice in withWhiteSpaceChoices {
        choices.append(choice.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    return choices
}

func separateKeyValue(_ mixedPair: String) -> (String, String) {
    let keyValueList = mixedPair.split(separator: ":")
    let value = keyValueList[1].trimmingCharacters(in: .whitespaces)
    let key = keyValueList[0].trimmingCharacters(in: .whitespaces) + value
    return (key, value)
}

func handleFollowUpQuestions(_ followUpQuestionStr: String) -> [[String:Int]] {
    var returnDict: [[String: Int]] = []
    let followUpList = followUpQuestionStr.split(separator: ";")
    
    for followUp in followUpList {
        let cleanFollowUp = followUp.trimmingCharacters(in: .whitespaces)
        var singleDict: [String:Int] = [:]
        
        // Contain multiple vaccine results
        if cleanFollowUp.firstIndex(of: ",") != nil {
            let dictList = cleanFollowUp.split(separator: ",")
            for dict in dictList {
                let (key, value) = separateKeyValue(String(dict))
                singleDict.updateValue(Int(value) ?? 1, forKey: key)
            }
        }
        // Only one vaccine / question
        else {
            let (key, value) = separateKeyValue(String(cleanFollowUp))
            singleDict.updateValue(Int(value) ?? 1, forKey: key)
        }
        
        returnDict.append(singleDict)
    }
    
    return returnDict
}

//  MARK: - JSON Conversion Extension
extension Collection where Iterator.Element == [String:Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

//  MARK: - Saved MixedJSON containing both types of data
class MixedJSON: Codable {
    var type: String
    var id: String
    var name: String
    var instruction: String
    var questionText: String
    var choice: [String]
    var answer: String
    var followUpQuestions: [[String:Int]]
    
    init(type: String, id: String, name: String, instruction: String, questionText: String, choice: [String], answer: String, followUpQuestions: [[String : Int]]) {
        self.type = type
        self.id = id
        self.name = name
        self.instruction = instruction
        self.questionText = questionText
        self.choice = choice
        self.answer = answer
        self.followUpQuestions = followUpQuestions
    }
}

// Load JSON - store as Questions & Vaccines
func loadMixedJSON(_ JSONString: String) {
    let decoder = JSONDecoder()
    var loadArray = [MixedJSON]()
    let dataString = JSONString.data(using: .utf8)
    
    do {
        let decoded = try decoder.decode([MixedJSON].self, from: dataString!)
        loadArray = decoded
    } catch {
        print("ERROR: \(error)")
    }
    MixedJSONToQuestionVaccine(loadArray)
}

func MixedJSONToQuestionVaccine(_ JSONArray: [MixedJSON]) {
    for json in JSONArray {
        if json.type.lowercased() == "question" {
            let intID = Int(json.id)
            let newQuestion = Question(id: intID!, questionText: json.questionText, choice: json.choice, answer: json.answer, followUpQuestions: json.followUpQuestions)
            questionList.append(newQuestion)
        } else if json.type.lowercased() == "vaccine" {
            let intID = Int(json.id)
            let newVaccine = Vaccine(id: intID!, name: json.name, instruction: json.instruction)
            vaccineList.append(newVaccine)
        }
    }
    print("Questions: \(questionList)\nVaccines: \(vaccineList)")
    db.questionList = questionList
    db.vaccineList = vaccineList
}
