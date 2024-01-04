//
//  FirebaseStorage.swift
//  Seamless
//
//  Created by Young Li on 11/7/23.
//
//  Source: Usage of Firebase Storage API & tutorial https://firebase.google.com/docs/storage/ios/start

import Foundation
import UIKit

// Create storage reference
let storageRef = firebaseStorage.reference()

// MARK: - Firebase Storage CRUD methods - survey notes
func uploadPhoto(survey: Survey, uploadImage: UIImage) {
    
    // Specify the file path and name
    let imageData = uploadImage.jpegData(compressionQuality: 0.8)
    guard imageData != nil else { return }
    
    // Turn our image into data
    let path = "images/\(survey.surveyId.uuidString).jpg"
    let fileRef = storageRef.child(path)
    survey.note = path
    
    // Upload the data - simply rewrite the formal note jpg for now
    _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        if error == nil && metadata != nil {
            print("Successful note image upload!")
            updateSurveyNoteInFireStore(from: "surveys", withId: survey.surveyId, note: path)
        } else {
            print("Error in note image upload!")
        }
    }
}

func deletePhoto(survey: Survey) {
    let path = "images/\(survey.surveyId.uuidString).jpg"
    
    // Create a reference to the file to delete
    let desertRef = storageRef.child(path)

    // Delete the file
    desertRef.delete { error in
      if let err = error {
        // Uh-oh, an error occurred!
        print("Error removing document: \(err)")
      } else {
        // File deleted successfully
        print("Document successfully removed!")
      }
    }
}
    

