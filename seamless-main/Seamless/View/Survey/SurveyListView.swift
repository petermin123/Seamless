//
//  SurveyListView.swift
//  Seamless
//
//  Created by Young Li on 10/22/23.
//

import SwiftUI
import StoreKit

struct SurveyListView: View {
    // Environment objects and state variables
    @EnvironmentObject var modelData: ModelData
    @Environment(\.requestReview) var requestReview
    @State var searchText = ""
    @State private var editNote = false
    @State private var showNote = false
    @State private var showScanner = false
    @State private var isTyping = false
    @State private var currentSurvey: Survey = defaultSurvey
    @State private var isAscending = true
    
    var postQRCodeScan = true
    // Filtered list based on search text
    var filteredList: [Survey] {
        let filterSurvey = modelData.surveyList
        return searchText.isEmpty ? filterSurvey : filterSurvey.filter { $0.description.lowercased().contains(searchText.lowercased()) }
    }
    // Group surveys by status
    var statusGroup: [String: [Survey]] {
        Dictionary(
            grouping: filteredList,
            by: { $0.status.rawValue }
        )
    }
    
    
    
    var body: some View {
        NavigationView {
            if !postQRCodeScan && filteredList.count == 0 {
                // Message for empty or scanned surveys
                Text("Nothing to show here! The QR code you scanned most likely have its associated survey deleted already while the QR code image is still accessible. Please try a different QR code.")
            } else {
                VStack {
                    if postQRCodeScan {
                        // Search bar
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(color: Color.blue.opacity(0.2), radius: 5, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(isTyping ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            // Magnifying glass icon
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(isTyping ? .blue : .gray)
                                    .padding(.leading, 16)
                                    .onTapGesture {
                                        withAnimation {
                                            isTyping = true
                                        }
                                    }
                                
                                TextField("Search", text: $searchText)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 3)
                            }
                            .padding(.horizontal, 8)
                        }
                        .frame(height: 60)
                        .padding()
                        // Sort button
                        Button(action: {
                            withAnimation {
                                isAscending.toggle()
                                // Perform background tasks here
                                DispatchQueue.global(qos: .background).async {
                                    DispatchQueue.main.async {
                                        // Update the UI on the main thread here
                                        if isAscending {
                                            modelData.sortSurveysByDateAscending()
                                        } else {
                                            modelData.sortSurveysByDateDescending()
                                        }
                                    }
                                }
                            }
                        }) {
                            Label("Sort by Date", systemImage: isAscending ? "arrow.up" : "arrow.down")
                        }
                        .padding()
                    }
                    // Survey list
                    List {
                        ForEach(statusGroup.keys.sorted(), id: \.self) { key in
                            let surveys = statusGroup[key]
                            let size = String(surveys?.count ?? 0)
                            Section(header:
                                HStack {
                                    if let surveys = surveys, !surveys.isEmpty {
                                        let completionRate = modelData.calculateCompletionRate(surveys: surveys)
                                        Text("\(key) - \(size) (\(completionRate)%)")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.35, green: 0.83, blue: 0.91))
                                            .padding(.vertical, 2)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    } else {
                                        Text("\(key) - \(size)")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.35, green: 0.83, blue: 0.91))
                                            .padding(.vertical, 2)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                }
                            ){
                                ForEach(surveys ?? []) { survey in
                                    SurveyRow(survey: survey)
                                        .swipeActions {
                                            Button(role: .destructive){
                                                // Delete survey action
                                                currentSurvey = survey
                                                if modelData.delete(currentSurvey.surveyId) {
                                                    print("Succeed to delete")
                                                    deleteSurveyFromFirestore(for: "surveys", withId: currentSurvey.surveyId)
                                                    if !currentSurvey.note.isEmpty {
                                                        deletePhoto(survey: currentSurvey)
                                                    }
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            .tint(.red)
                                            
                                            Button {
                                                // Edit note action
                                                editNote = true
                                                currentSurvey = survey
                                            } label: {
                                                Label(title: {Text("Edit")}, icon: { Image(systemName: "square.and.pencil") } )
                                            }
                                            .tint(.blue)
                                            
                                            Button {
                                                // View note action
                                                showNote = true
                                                currentSurvey = survey
                                            } label: {
                                                Label(title: {Text("View")}, icon: { Image(systemName: "text.viewfinder") } )
                                            }
                                            .tint(.green)
                                        }
                                        .padding(.vertical, 2)
                                }
                            }
                            .padding()
                        }
                    }
                    .listStyle(PlainListStyle())
                    .sheet(isPresented: $showScanner) {
                        ScannerView()
                    }
                    // Allows for background thread for faster downloading
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                getSurveysForListView(from: "surveys")
                                if modelData.surveyList.count % 5 == 0 {
                                    requestReview()
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $editNote) {
                        EditNoteView(isNoteShown: $editNote, survey: currentSurvey)
                    }
                    .sheet(isPresented: $showNote) {
                        NoteImageView(isNoteShown: $showNote, survey: currentSurvey)
                    }
                    .navigationTitle("Survey List")
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            if postQRCodeScan {
                                Button {
                                    showScanner = true
                                } label: {
                                    Label("Scan", systemImage: "qrcode.viewfinder")
                                }
                            }
                        }
                    }
                    .font(Font.custom("Gluten-Bold", size: 20))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $modelData.showShareSheet) {
            modelData.PDFUrl = nil
        } content: {
            if let _ = modelData.PDFUrl {
                ShareSheet(urls: [modelData.PDFUrl!])
            }
        }
    }
}

#Preview {
    HomePageView(survey: Survey())
}
