//
//  HomeView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 27/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestoreInternal

struct HomeView: View {
    
    @Binding var presentSideMenu: Bool
    @State private var search: String = ""
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader{_ in 
                LinearGradient(
                    gradient: Gradient(colors: [.lightPurple, .white, .white, .white, .white, .white, Color("dogoImageColor").opacity(0.5)]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack (spacing: 23){
                    HStack (spacing: 16){
                        Button{
                            presentSideMenu.toggle()
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("menuIconColor"))
                        }
                        
                        HStack(spacing: 2) {
                            let displayName = AuthManager.auth.currentUser?.displayName ?? ""
                            textView(text: "Hello", font: "Poppins-Regular", fontSize: 24, color: "blackColor")
                            textView(text: ", \(displayName.components(separatedBy: " ").first ?? "")", font: "Poppins-Bold", fontSize: 24, color: "blackColor")
                        }
                        Spacer()
                        
                        Image(systemName: "bell.badge")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("menuIconColor"))
                    }
                    .padding(.horizontal, 16)
                    
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color("greyIconCOlor"))
                        ZStack(alignment: .leading) {
                            if search.isEmpty {
                                Text("Search by location, name ...")
                                    .foregroundColor(Color("greyIconCOlor"))
                            }
                            TextField("", text: $search)
                                .foregroundColor(Color("blackColor"))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color("textfieldColor"))
                    .cornerRadius(8)
                    .shadow(color: Color("textfieldColor"), radius: 5, x: 0, y: 0)
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Rectangle()
                            .fill(Color("dogoImageColor"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 130)
                            .cornerRadius(8)
                            .overlay {
                                HStack(spacing: -6) {
                                    VStack {
                                        Image("homeImage")
                                            .resizable()
                                            .frame(width: 157, height: 150)
                                            .cornerRadius(8)
                                    }
                                    .offset(y: -10)
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        VStack(alignment: .trailing)  {
                                            HStack {
                                                textView(text: "Otto is giving you", font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                                                textView(text: "20%", font: "Poppins-Black", fontSize: 28, color: "blackColor")
                                            }
                                            textView(text: "on your first booking", font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                                        }
                                        BookingNavigation(viewName: BookingView(presentSideMenu: .constant(true)), text: "Enjoy", width: 74, font: "Poppins-Medium", fontSize: 16, height: 34)
                                    }
                                }
                                .padding(.trailing)
                            }
                    }
                    .padding(.horizontal, 16)
                    
                    VStack (spacing: 16) {
                        HStack {
                            textView(text: "Your next tour", font: "Poppins-SemiBold", fontSize: 16, color: "blackColor")
                            Spacer()
                        }
                        
                        HStack {
                            Rectangle()
                                .fill(.clear)
                                .frame(maxWidth: .infinity)
                                .frame(height: 116)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("menuShadowColor"), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                                .overlay {
                                    HStack {
                                        let booking = viewModel.recentBooking
                                        VStack {
                                            HStack (spacing: 8) {
                                                WebImage(url: URL(string: viewModel.dogSitterImage))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 32, height: 32)
                                                    .cornerRadius(50)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color("yellowColor"))
                                                    .cornerRadius(50)
                                                textView(text: booking?.sitter ?? "Emily T", font: "Poppins-Regular", fontSize: 16, color: "blackColor")
                                                Spacer()
                                            }
                                            
                                            HStack (spacing: 8) {
                                                Image("map-pin")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 16, height: 16)
                                                textView(text: "In your home", font: "Poppins-Medium", fontSize: 14, color: "blackColor")
                                                Spacer()
                                            }
                                            
                                            HStack (spacing: 8) {
                                                Image(systemName: "calendar")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 16, height: 16)
                                                    .foregroundColor(Color("yellowColor"))
                                                textView(text: "\(booking?.startTime ?? "8:00") - \(booking?.endTime ?? "9:00")" , font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                                                Spacer()
                                            }
                                        }
                                        .padding(.leading, 16)
                                        
                                        Spacer()
                                        
                                        VStack {
                                            let date = booking?.date ?? Timestamp(date: Date())
                                            let components = viewModel.extraDate(timestamp: date)
                                            textView(text: components[1] , font: "Poppins-Medium", fontSize: 16, color: "blackColor")
                                            textView(text: components[0] , font: "Poppins-SemiBold", fontSize: 24, color: "blackColor")
                                        }
                                        .padding(.trailing, 16)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    VStack (spacing: 10) {
                        HStack {
                            textView(text: "Popular", font: "Poppins-SemiBold", fontSize: 16, color: "blackColor")
                            Spacer()
                            Button {
                                
                            } label: {
                                textView(text: "See all", font: "Poppins-SemiBold", fontSize: 14, color: "buttonColor")
                            }
                            
                        }
                        .padding(.horizontal, 16)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .task {
                                    viewModel.fetchData()
                                    viewModel.fetchDogSitterImage()
                                    viewModel.getRecentBooking()
                                }
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.dogSitters, id: \.id) {dogSitter in
                                        VStack (alignment: .leading) {
                                            ZStack {
                                                WebImage(url: URL(string: dogSitter.profile))
                                                    .resizable()
                                                    .indicator(.activity)
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 130, height: 130)
                                                    .cornerRadius(8)
                                                ZStack {
                                                    textView(text: "  $\(dogSitter.charges)/hour  ", font: "Poppins-Medium", fontSize: 12, color: "white")
                                                        .frame(width: 70, height: 26)
                                                        .background(Color("buttonColor"))
                                                        .cornerRadius(50)
                                                        .offset(x: 35, y: -60)
                                                }
                                            }
                                            textView(text: dogSitter.name, font: "Poppins-Medium", fontSize: 16, color: "blackColor")
                                            HStack (spacing: 0) {
                                                ForEach(0..<dogSitter.rating) {_ in
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(Color("ratingColor"))
                                                        .overlay {
                                                            Image(systemName: "star")
                                                                .foregroundColor(Color("menuShadowColor"))
                                                        }
                                                }
                                                ForEach(0..<(5 - dogSitter.rating)) {_ in
                                                    Image(systemName: "star")
                                                        .foregroundColor(Color("ratingColor"))
                                                        .overlay {
                                                            Image(systemName: "star")
                                                                .foregroundColor(Color("menuShadowColor"))
                                                        }
                                                }
                                                
                                            }
                                            textView(text: "\(dogSitter.tours) tours", font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                                        }
                                    }
                                }
                                .padding(.trailing, 16)
                                .padding(.top, 10)
                                .padding(.leading, 16)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 10)
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    HomeView(presentSideMenu: .constant(true))
}
