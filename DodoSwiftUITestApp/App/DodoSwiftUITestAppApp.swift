//
//  DodoSwiftUITestAppApp.swift
//  DodoSwiftUITestApp
//
//  Created by Dev on 23/05/2024.
//

import SwiftUI
import GoogleSignIn

@main
struct DodoSwiftUITestAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authenticationViewModel.isUserAuthenticated {
                MainTabbedView().onOpenURL { url in
                    //Handle Google Oauth URL
                    GIDSignIn.sharedInstance.handle(url)
                }
            } 
            else {
                SplashView(showHomeView: false).onOpenURL { url in
                    //Handle Google Oauth URL
                    GIDSignIn.sharedInstance.handle(url)
                }
            }
        }
    }
}
