//
//  ThankyouView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 31/05/2024.
//

import SwiftUI

struct ThankyouView: View {
    var body: some View {
        VStack(spacing: 24) {
            NavigationHeader(viewName: BookingView(presentSideMenu: .constant(true)))
            Spacer()
            VStack(alignment: .center) {
                Image("thankyou")
                textView(text: "Your pet's walk has been booked!", font: "Poppins-Regular", fontSize: 24, color: "blackColor")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 62)
            }
            Spacer()
            VStack {
                BookingNavigation(viewName: MainTabbedView(), text: "Back to home", width: .infinity, font: "Poppins-Regular", fontSize: 24, height: 50)
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .background(Color("white"))
    }
}

#Preview {
    ThankyouView()
}
