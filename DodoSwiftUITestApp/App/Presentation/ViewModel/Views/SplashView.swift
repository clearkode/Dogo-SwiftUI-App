//
//  SplashView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 24/05/2024.
//

import SwiftUI
import AuthenticationServices

struct SplashView: View {
    
    @State var showLoginView: Bool = false
    @State var password: String = ""
    @State var showHomeView: Bool
    @State private var email: String = ""
    @State private var isSecured: Bool = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSigningIn = false
    
    var body: some View {
        NavigationView {
            CurveShape()
                .fill(showLoginView ? .white : Color("lightBackgroundColor"))
                .scaleEffect(CGSize(width: showLoginView ? 1.3 : 2.5, height: showLoginView ? 1 : 3.5))
                .background(Color("backgroundColor"))
                .shadow(color: Color("shadowColor"), radius: 30, x: 0, y: 0)
                .overlay() {
                    if showLoginView {
                        LoginViewContent("Enter your password", password: $password, email: $email, isSecured: $isSecured, showAlert: $showAlert, alertMessage: $alertMessage, showHomeView: $showHomeView, isSigningIn: $isSigningIn).body
                    } else {
                        SplashViewContent().body
                    }
                    
                }
            
                .clipped()
                .ignoresSafeArea()
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                        withAnimation {
                            self.showLoginView = true
                        }
                    }
                }
        }
    }
}

#Preview {
    SplashView(showHomeView: false)
}

struct DogoTextView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(Font.custom("Lobster-Regular", size: 96))
            .foregroundColor(.white)
    }
}

struct SubTextView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(Font.custom("Mansalva-Regular", size: 28))
            .foregroundColor(.white)
    }
}

protocol ContentViewProtocol {
    associatedtype view: View
    var body: view { get }
}

struct SplashViewContent: View, ContentViewProtocol {
    var body: some View {
        VStack {
            DogoTextView(text: "Dogo")
            SubTextView(text: "Where Every Walk is")
            SubTextView(text: "Tail-Wagging Fun!")
        }
    }
}

struct LoginViewContent: View, ContentViewProtocol {
    
    @Binding private var showHomeView: Bool
    @Binding private var email: String
    @Binding private var password: String
    @Binding private var isSecured: Bool
    @Binding private var showAlert: Bool
    @Binding private var alertMessage: String
    @Binding private var isSigningIn: Bool
    
    private var passwordTitle: String = "Enter your password"
    
    init(_ passwordTitle: String, password: Binding<String>, email: Binding<String>, isSecured: Binding<Bool>, showAlert: Binding<Bool>, alertMessage: Binding<String>, showHomeView: Binding<Bool>, isSigningIn: Binding<Bool>  ) {
        self.passwordTitle = passwordTitle
        self._password = password
        self._email = email
        self._isSecured = isSecured
        self._showAlert = showAlert
        self._alertMessage = alertMessage
        self._showHomeView = showHomeView
        self._isSigningIn = isSigningIn
    }
    
    var body: some View {
        let _ = SecureField(passwordTitle, text: $password)
        let _ = TextField(passwordTitle, text: $password)
        VStack {
            Spacer()
                .padding(.top, 57)
            DogoTextView(text: "Dogo")
            SubTextView(text: "Paw Walkers")
            Circle()
                .shadow(color: .gray, radius: 5, x: 0, y: 0)
                .frame(width: 221, height: 222)
                .foregroundColor(Color("dogoImageColor"))
                .overlay(
                    GeometryReader { geometry in
                        Image("DogoImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 221, height: 222)
                            .clipShape(Circle())
                    }
                )
            
            Text("Sign in")
                .font(Font.custom("Poppins-Regular", size: 18))
                .foregroundColor(Color("blackColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            HStack(alignment: .top) {
                Image(systemName: "envelope.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color("greyIconCOlor"))
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("Enter your e-mail")
                            .foregroundColor(Color("greyIconCOlor"))
                    }
                    TextField("", text: $email)
                        .foregroundColor(Color("blackColor"))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color("textfieldColor"))
            .cornerRadius(8)
            .padding(.horizontal)
            .shadow(color: Color("textfieldColor"), radius: 5, x: 0, y: 0)
            .padding(.bottom, 12)
            
            HStack(alignment: .top) {
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color("greyIconCOlor"))
                Group {
                    if isSecured {
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text(passwordTitle)
                                    .foregroundColor(Color("greyIconCOlor"))
                            }
                            SecureField("", text: $password)
                                .foregroundColor(Color("blackColor"))
                        }
                    } else {
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text(passwordTitle)
                                    .foregroundColor(Color("greyIconCOlor"))
                            }
                            TextField("", text: $password)
                                .foregroundColor(Color("blackColor"))
                        }
                        
                    }
                }
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(Color("greyIconCOlor"))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color("textfieldColor"))
            .cornerRadius(8)
            .padding(.horizontal)
            .shadow(color: Color("textfieldColor"), radius: 5, x: 0, y: 0)
            
            
            HStack {
                Text("Not registered yet?")
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color("blackColor"))
                
                Button(action: {
                    //action code
                }) {
                    Text("Sign up")
                        .font(Font.custom("Poppins-Bold", size: 14))
                        .foregroundColor(Color("blackColor"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Button(action: {
                self.isSigningIn = true
                LoginViewModel().SignIn(email: email, password: password) { showHomeView, error in
                    if showHomeView {
                        let emailComponents = email.components(separatedBy: "@")
                        let username = emailComponents.first ?? "Unknown"
                        let userRef = AuthManager.db.collection("users").document(AuthManager.auth.currentUser!.uid)
                        userRef.setData(["username": username], merge: true) { error in
                            if let error = error {
                                print("Error adding document: \(error.localizedDescription)")
                            } else {
                                self.showHomeView = showHomeView
                            }
                        }
                    } else {
                        if let error = error {
                            self.showAlert = true
                            self.alertMessage = error.localizedDescription
                        }
                    }
                    self.isSigningIn = false
                }
            }) {
                if isSigningIn {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
            }
            .font(Font.custom("Poppins-Medium", size: 20))
            .frame(height: 50)
            .background(Color("buttonColor"))
            .cornerRadius(8)
            .padding(.horizontal)
            .foregroundColor(.white)
            .disabled(isSigningIn)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
                .padding(.vertical, 8)
            
            VStack {
                Text("Or continue with")
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .foregroundColor(Color("blackColor"))
                HStack() {
                    Button(action: {
                        // action
                    }) {
                        HStack {
                            Image("facebook")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 30.67)
                                .foregroundColor(Color("facebookColor"))
                            Text("Facebook")
                                .font(Font.custom("Montserrat-Medium", size: 14))
                        }
                        .padding(10)
                        .background(Color("textfieldColor"))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 46.67)
                    .disabled(isSigningIn)
                    
                    Button(action: {
                        // action
                        self.isSigningIn = true
                        Task.detached { @MainActor in
                            do {
                                try await AuthManager.shared.googleOauth { result in
                                    showHomeView = result
                                    self.isSigningIn = false
                                }
                            } catch let e {
                                print(e)
                                self.isSigningIn = false
                                let err = e.localizedDescription
                            }
                        }
                    }) {
                        HStack {
                            Image("Google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 30.67)
                            Text("Google")
                                .font(Font.custom("Montserrat-Medium", size: 14))
                        }
                        .padding(10)
                        .background(Color("textfieldColor"))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 46.67)
                    .disabled(isSigningIn)
                    
                    Spacer()
                    
                    SignInWithAppleButton(.signIn) { request in
                        // authorization request for an Apple ID
                    } onCompletion: { result in
                        self.isSigningIn = true
                        // completion handler that is called when the sign-in completes
                        switch result {
                        case .success(let authorization):
                            LoginViewModel().appleLogin(authorization: authorization) { showHomeView in
                                DispatchQueue.main.async {
                                    self.showHomeView = showHomeView
                                    self.isSigningIn = false
                                }
                            }
                        case .failure(let error):
                            print("Could not authenticate: \(error.localizedDescription)")
                            self.isSigningIn = false
                        }
                    }
                    .disabled(isSigningIn)
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 46.67)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 67)
            
            Spacer()
        }
        NavigationLink("", destination:  MainTabbedView().navigationBarBackButtonHidden(true), isActive: $showHomeView)
            .navigationBarTitle("")
    }
    
}
