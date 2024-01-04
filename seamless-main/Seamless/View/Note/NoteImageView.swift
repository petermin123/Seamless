//
//  NoteImageView.swift
//  Seamless
//
//  Created by Young Li on 11/4/23.
//
//  Source: Firebase Storage IOS tutorial

import SwiftUI

struct NoteImageView: View {
    @Binding var isNoteShown: Bool
    var survey: Survey
    
    @State private var images: [UIImage] = []
    @State private var errMsg: String = ""
    
    var body: some View {
        if survey.note.isEmpty {
            Text("No note!")
        } else {
            VStack {
                if errMsg.isEmpty {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                    }
                } else {
                    Text(errMsg)
                }
            }
            .onAppear {
                retrievePhotoURL()
            }
        }
    }
    
    //  Firebase Storage Download image method
    func retrievePhotoURL() {
        let retrievedData = storageRef.child(survey.note)
        
        retrievedData.getData(maxSize: Int64(5 * 1024 * 1024)) { data, error in
            if error == nil {
                if let image = UIImage(data: data!){
                    DispatchQueue.main.async {
                        images.append(image)
                    }
                }
            } else {
                print("retrieveERROR: \(error?.localizedDescription ?? "none")")
                errMsg = "\(error?.localizedDescription ?? "none"), please try again"
            }
        }

    }
}

#Preview {
    NoteImageView(isNoteShown: .constant(true), survey: defaultSurvey)
}
