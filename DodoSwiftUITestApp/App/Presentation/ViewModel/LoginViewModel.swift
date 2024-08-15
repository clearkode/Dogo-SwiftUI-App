//
//  LoginViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 03/06/2024.
//

import Foundation
import AuthenticationServices

class LoginViewModel {
    
    func SignIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        AuthManager.shared.SignUp(email: email, password: password) { showHomeView, error in
            if showHomeView {
                LogService.log("Login: Successfull")
                completion(showHomeView, error)
            } else if let error = error {
                LogService.log("Login: Unsuccessfull, Authentication failed: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }
    
    func appleLogin(authorization: ASAuthorization, completion: @escaping(Bool) -> Void ) {
        AuthManager.shared.appleLogin(authorization: authorization) { showHomeView in
            LogService.log("Apple Login: Successfull")
            completion(showHomeView)
        }
    }
    
}

class TestLoginViewModel {
    func SignIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        if email == "a@a.com" && password == "123456" {
            completion(true, nil)
        } else {
            completion(false, "error")
        }
    }
}
