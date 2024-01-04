//
//  Constant.swift
//  Seamless
//
//  Created by Young Li on 10/22/23.
//

import Foundation
import UserNotifications
import UIKit

// MARK: ContentView Strings
let appName = "Seamless"
let appDescription = "Your go-to choice for reliable recommendations of vaccines for organ transplant patients"
let startSurvey = "Start survey"
let listSurvey = "List existing surveys"
let helpStr = "Help"
let statStr = "Stats"

// MARK: - VaccineView Strings
let vaccineChoice = "Choose your vaccine type"

// MARK: - ResultView Strings
let congrats = "Congratulations"
let qrcodeStr = "Generate QR Code"
let homeStr = "Home"
let policyStr = "Policy"

// MARK: - HelpView Strings
let helpInstruction = """
Here is how to navigate through the survey:\n
1. Press the buttons on the screen to answer questions\n
2. Once all questions are finished, you will be shown a recommendation of vaccines to take\n
In the final screen, you can:\n
1. Generate a distinct QR code for the survey you just finished\n
2. Go back to home page\n
3. View details of the vaccination policy\n
"""

let helpInstructionPartI = """
Here is how to navigate through the survey:
1. Press the buttons on the screen to answer questions
2. Once all questions are finished, you will be shown a recommendation of vaccines to take
"""

let helpInstructionPartII = """
In the final screen, you can:
1. Generate a distinct QR code for the survey you just finished
2. Go back to home page
3. View details of the vaccination policy
"""

// MARK: - QRCodeView Strings
let qrcodeTitle = "QR Code"
let qrcodeInstruction = """
Survey info saved!\n
Take a screenshot\n
for your reference
"""
let qrcodeDownload = "Download"

// MARK: - RatingView Strings
let rateApp = "Rating"

// MARK: - Stats Strings
let ratingStat = "Rating Stats"

// MARK: - ModelData constants
let db = ModelData.shared
let filemgr = FileManager.default
let defaultUrl: URL = getDocumentsDirectory()

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

/*
 Source: ece564 communication storage gitlab demo
 */
// convert images to base64 images
func stringFromImage(_ imagePic: UIImage) -> String {
    let picImageData: Data = imagePic.jpegData(compressionQuality: 0.2)!
    let picBase64 = picImageData.base64EncodedString()
    return picBase64
    
}

/*
 Source: https://www.hackingwithswift.com/forums/swiftui/encode-image-uiimage-to-base64/10103
 It helps me to encode base64 to uiimage
 */
extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}


// MARK: - Notification Constants
let notificationIdentifier = "survey-complete-notification"

func pushNotify() {
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Congratulations!"
    notificationContent.body = "You just finished a survey."
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: trigger)
    
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

// MARK: - Default testing objects
let defaultQuestion = Question(
    id: 1,
    questionText: "Hep B Status",
    choice: ["Hep B antibody positive", "Hep B surface antigen and antibody negative", "Hep B surface antigen positive antibody negative"],
    answer: "",
    followUpQuestions: [
        [
            "Vaccine": 1
        ],
        [
            "Question": 2
        ],
        [
            "Vaccine": 2
        ]
    ]
)

let defaultVaccine = Vaccine(
    id: 1,
    name: "Next",
    instruction: "No Vaccination needed"
)

let defaultPic: UIImage? = UIImage(named: "hospital")

let defaultSurvey = Survey(note: "")

let ratingContext = ["1", "2", "3", "4", "5"]

