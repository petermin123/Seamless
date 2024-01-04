//
//  SeamlessApp.swift
//  Seamless
//
//  Created by Young Li on 10/21/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAppCheck

// Cloud FireStore & Firebase Storage instance setup
let firebaseDB = Firestore.firestore()
let firebaseStorage = Storage.storage()

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Firebase access configuration
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        
        // User Notification enabling
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, _ in
            guard success else { return }
            print("Successfully requested user authorization.")
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

@main
struct SeamlessApp: App {
    @StateObject private var modelData = ModelData.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(saveTasks: {
                if !modelData.saveJSON() {
                    print("Fail to save bundle list!")
                } else {
                    print("Succeed to save bundle list!")
                }
            })
            .environmentObject(modelData)
            .onAppear {
                parseCSV()
            }
        }
    }
}
