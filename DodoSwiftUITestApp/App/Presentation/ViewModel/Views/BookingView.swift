//
//  BookingView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 28/05/2024.
//

import SwiftUI
import FirebaseFirestoreInternal

struct BookingView: View {
    @Binding var presentSideMenu: Bool
    
    @StateObject var viewModel = BookingViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .white, .white, .white, .white, Color("menuIconColor")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5, anchor: .center)
                    } else {
                        bookingHeaderView(presentSideMenu: $presentSideMenu)
                            .padding(.horizontal, 24)
                            .padding(.top, 10)
                            .environmentObject(viewModel)
                    }
                }
                .task {
                    viewModel.fetchBookingData()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct textView: View {
    var text: String
    var font: String
    var fontSize: CGFloat
    var color: String
    var body: some View {
        Text(text)
            .font(Font.custom(font, size: fontSize))
            .foregroundColor(Color(color))
    }
}

struct bookingHeaderView: View {
    @State var gotoHome: Bool = false
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var viewModel: BookingViewModel
    var body: some View {
        VStack(spacing: 0){
            NavigationHeader(viewName: MainTabbedView())
            
            if viewModel.noOfBooking != 0 {
                ScrollView (.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.groupedBookings.keys.sorted(), id: \.self) { month in
                            Section {
                                HStack {
                                    textView(text: month.components(separatedBy: " ").first ?? "Month", font: "Poppins-SemiBold", fontSize: 16, color: "blackColor")
                                    Spacer()
                                }
                                ForEach(viewModel.groupedBookings[month]!, id: \.id) { booking in
                                    let date = booking.date.dateValue()
                                    let calendar = Calendar.current
                                    let dayOfMonth = calendar.component(.day, from: date)
                                    Bookings(sitter: booking.sitter, date: "\(dayOfMonth)", Month: month.components(separatedBy: " ").first ?? "Month", timeStart: booking.startTime, timeEnd: booking.endTime)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 77)
                    Spacer()
                }
                .overlay {
                    BookingButton()
                        .offset(y: 270)
                }
                .padding(.top, 40)
            } else {
                Spacer()
                VStack(spacing: 20) {
                    textView(text: "No Bookings Yet!", font: "Poppins-Bold", fontSize: 32, color: "blackColor")
                    textView(text: "Click Below to Schedule your First Booking!↓", font: "Poppins-Medium", fontSize: 12, color: "blackColor")
                    BookingNavigation(viewName: BookingScheduleView(), text: "Schedule Booking", width: .infinity, font: "Poppins-Regular", fontSize: 24, height: 50)
                }
                Spacer()
            }
        }
    }
}

struct BookingButton: View {
    var body: some View {
        BookingNavigation(viewName: BookingScheduleView(), text: "Booking", width: .infinity, font: "Poppins-Regular", fontSize: 24, height: 50)
        .offset(y: 65)
    }
}

struct BookingNavigation<Content: View>: View {
    @State var viewName: Content
    @State var text: String
    @State var width: CGFloat
    @State var font: String
    @State var fontSize: CGFloat
    @State var height: CGFloat
    
    var body: some View {
        NavigationLink() {
            viewName
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            
        } label: {
            textView(text: text, font: font, fontSize: fontSize, color: "white")
                .frame(maxWidth: width)
                .frame(height: height)
                .background(Color("buttonColor"))
                .cornerRadius(8)
        }
    }
}

struct NavigationHeader<Content: View>: View {
    @State var viewName: Content
    var body: some View {
        HStack(spacing: 18){
            NavigationLink() {
                viewName
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                    .navigationViewStyle(.columns)
                
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .foregroundColor(Color("menuIconColor"))
            }
            textView(text: "Bookings", font: "Poppins-Regular", fontSize: 24, color: "blackColor")
            Spacer()
            Image(systemName: "bell.badge")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color("menuIconColor"))
        }
    }
}

struct Bookings: View {
    var sitter: String
    var date: String
    var Month: String
    var timeStart: String
    var timeEnd: String
    
    var body: some View
    {
        HStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 102)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("textfieldColor1"), lineWidth: 0.5)
                    .shadow(radius: 5)
                )
                .overlay {
                    HStack {
                        VStack (spacing: 5) {
                            HStack (spacing: 8) {
                                textView(text: sitter, font: "Poppins-Regular", fontSize: 14, color: "blackColor")
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
                                textView(text: "\(timeStart) - \(timeEnd)", font: "Poppins-Regular", fontSize: 14, color: "blackColor")
                                Spacer()
                            }
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        VStack {
                            textView(text: Month, font: "Poppins-Medium", fontSize: 16, color: "blackColor")
                            textView(text: date, font: "Poppins-SemiBOld", fontSize: 24, color: "blackColor")
                        }
                        .padding(.trailing, 16)
                    }
                }
        }
    }
}

#Preview {
    BookingView(presentSideMenu: .constant(true))
}
