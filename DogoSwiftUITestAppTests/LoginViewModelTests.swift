//
//  LoginViewModelTests.swift
//  DogoSwiftUITestAppTests
//
//  Created by Dev on 09/06/2024.
//

import XCTest
@testable import DogoSwiftUITestApp

class LoginViewModelTests: XCTestCase  {
    private var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    func testLogin() async throws {
        viewModel.SignIn(email: "a@a.com", password: "123456") { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
        }
    }

}
