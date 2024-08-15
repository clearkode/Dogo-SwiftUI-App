//
//  SideMenuMainView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 28/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SideMenuMainView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 257)
                    .shadow(color: Color("menuShadowColor").opacity(1), radius: 200, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    DogoLogoView(text: "Dogo")
                    ProfileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    DividerView(padding: 20)
                        .offset(y: -40)
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title, label: row.label) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    DividerView(padding: 20)
                    LogoutView()
                }
                .padding(.top, 57)
                .frame(width: 257)
                .background(
                    Color("white")
                )
            }
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        HStack {
            if let imageURL = AuthManager.auth.currentUser?.photoURL {
                WebImage(url: imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding()
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .padding()
            }
            Spacer()
            VStack {
                let displayName = AuthManager.auth.currentUser?.displayName ?? ""
                textView(text: displayName.components(separatedBy: " ").first ?? "", font: "Montserrat-Regular", fontSize: 14, color: "blackColor")
                Button(action: {}, label: {
                    textView(text: "Edit profile", font: "Poppins-Medium", fontSize: 14, color: "darkBlackColor")
                })
            }
            .padding()
        }
        .frame(width: 209, height: 66)
        .background(Color("profileColor").opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal, 24)
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, label: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 10){
                    ZStack{
                        Image(imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("menuIconColor"))
                            .frame(width: 24, height: 24)
                    }
                    .frame(width: 24, height: 24)
                    textView(text: title, font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                    if label != "" {
                        textView(text: label, font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                            .frame(width: 23, height: 23)
                            .background(Color("yellowColor"))
                            .cornerRadius(50)
                    }
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 24)
    }
    
    func LogoutView() -> some View{
        Button(action: {
            try? AuthManager.auth.signOut()
            navigateToSplashView()
        }) {
            HStack {
                Image("logout")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .padding(.leading)
                textView(text: "Log out", font: "Poppins-Regular", fontSize: 16, color: "blackColor")
            }
            .padding(24)
        }
    }
    
    func navigateToSplashView() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: SplashView(showHomeView: false).navigationBarBackButtonHidden(true))
            window.makeKeyAndVisible()
        }
    }
    
    struct DogoLogoView: View {
        var text: String
        var body: some View {
            textView(text: text, font: "Lobster-Regular", fontSize: 49.66, color: "profileColor")
                .padding(.horizontal, 24)
        }
    }
}

struct DividerView: View {
    @State var padding: CGFloat
    var body: some View {
        Divider()
            .frame(height: 2)
            .overlay(Color("dividerColor"))
            .padding(.horizontal, padding)
    }
}

#Preview {
    SideMenuMainView(selectedSideMenuTab: .constant(0), presentSideMenu: .constant(true))
}
