//
//  FireStore.swift
//  Seamless
//
//  Created by Young Li on 11/5/23.
//
//  Source: Usage of Cloud FireStore API & tutorial https://firebase.google.com/docs/firestore/quickstart

import Foundation

// MARK: - Cloud FireStore CRUD methods - surveys
func addSurveyToFirestore(to collectionName: String, from survey: Survey) {
    firebaseDB.collection(collectionName).document("\(survey.surveyId)").setData([
        "questionList": "\(survey.questionList.map({ $0.questionText }))",
        "result": "\(survey.result)",
        "status": "\(survey.status)",
        "completedDate": survey.completedDate,
        "note": ""
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func getSurveysForListView(from collectionName: String) {
    firebaseDB.collection(collectionName).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let currentSurvey = Survey()
                currentSurvey.surveyId = UUID(uuidString: document.documentID)!
                currentSurvey.completedDate = document.data()["completedDate"] as! String
                currentSurvey.status = Status.allCases.first(where: {$0.rawValue == document.data()["status"] as! String})!
                currentSurvey.note = document.data()["note"] as! String
                if db.add(currentSurvey) {
                    print("Firestore survey added to data model")
                }
            }
        }
    }
}

func deleteSurveyFromFirestore(for collectionName: String, withId documentID: UUID) {
    firebaseDB.collection(collectionName).document(documentID.uuidString).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
}

func updateSurveyNoteInFireStore (from collectionName: String, withId documentID: UUID, note: String) {
    firebaseDB.collection(collectionName).document(documentID.uuidString).updateData(["note": note]) {
        err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated")
          }
    }
}

// MARK: - Cloud FireStore CRUD methods - ratings
func addRatingToFirestore(to collectionName: String, from rating: Rating) {
    firebaseDB.collection(collectionName).document("\(rating.id)").setData([
        "rating": rating.rating,
        "feedback": rating.feedback,
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func getRatingsForAnalysis(from collectionName: String) {
    var ratings: [Double] = [0, 0, 0, 0, 0]
    var feedbacks: [String] = []
    
    firebaseDB.collection(collectionName).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
                var currentRating = Rating(rating: 0, feedback: "")
                currentRating.id = UUID(uuidString: document.documentID)!
                currentRating.rating = document.data()["rating"] as! Int
                currentRating.feedback = document.data()["feedback"] as! String
                ratings[currentRating.rating - 1] += 1
                if !currentRating.feedback.isEmpty {
                    feedbacks.append(currentRating.feedback)
                }
            }
        }
        print("Ratings: \(ratings) - Feedbacks #: \(feedbacks.count)")
        db.updateRatingFeedbackLists(rating: ratings, feedback: feedbacks)
        db.updateRatingStatList()
    }
}

// MARK: - Cloud FireStore CRUD methods - extra
func countEntriesInFirebase(from collectionName: String) async -> Int {
    let query = firebaseDB.collection(collectionName)
    let countQuery = query.count
    do {
      let snapshot = try await countQuery.getAggregation(source: .server)
        return Int(truncating: (snapshot.count))
    } catch {
      print(error)
    }
    return 0
}
