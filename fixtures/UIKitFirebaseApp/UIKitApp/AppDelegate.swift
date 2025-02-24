//
//  AppDelegate.swift
//  UIKitApp
//
//  Created by Derian Córdoba on 23/2/25.
//

// This is an example of how to use the SecureKeys framework to retrieve the keys
// You can adjust this code to fit your needs

import UIKit
import FirebaseCore
import SecureKeys // Import the SecureKeys framework

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure the Firebase service with the firebase api key confirgured
        // in the SecureKeys framework
        if let plistFile = Bundle.main.path(forResource: "GoogleService-Info",
                                            ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: plistFile) {
            // Configure the firebase option keys
            options.apiKey = .key(for: .firebaseApiKey)
            options.gcmSenderID = key(for: .firebaseGcmSenderID)
            options.bundleID = key(.firebaseBundleID)
            options.projectID = "firebaseProjectID".secretKey.decryptedValue
            options.storageBucket = SecureKey.firebaseStorageBucket.decryptedValue
            options.googleAppID = .key(for: .firebaseGoogleAppID)
            
            // Initialize the firebase app
            FirebaseApp.configure(options: options)
            
            // Print message
            debugPrint("Firebase configured")
        }
        
        return true
    }
}
