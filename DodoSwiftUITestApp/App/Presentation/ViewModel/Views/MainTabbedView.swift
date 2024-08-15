//
//  MainTabbedView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 28/05/2024.
//

import SwiftUI

struct MainTabbedView: View {
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack{
            VStack {
                if selectedSideMenuTab == 0 {
                    HomeView(presentSideMenu: $presentSideMenu)
                    .tag(0)            }
                else if selectedSideMenuTab == 1 || selectedSideMenuTab == 2 || selectedSideMenuTab == 3 {
                    BookingView(presentSideMenu: $presentSideMenu)
                        .tag(1)
                }
            }
            .zIndex(0)
            if presentSideMenu {
                VStack {
                    Spacer()
                    SideMenuMainView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)
                    Spacer()
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut(duration: 0.4))
                .background(Color.black.opacity(0.3))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    presentSideMenu.toggle()
                }
                .zIndex(1)
            }
        }
    }
}

#Preview {
    MainTabbedView()
}
