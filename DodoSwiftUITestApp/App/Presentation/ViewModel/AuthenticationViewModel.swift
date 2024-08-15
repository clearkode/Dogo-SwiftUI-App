//
//  AuthenticationViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 08/06/2024.
//

import Foundation
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var isUserAuthenticated = false
    
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        LogService.log("Checking user authentication")
        self.isUserAuthenticated = AuthManager.auth.currentUser != nil
    }
}
