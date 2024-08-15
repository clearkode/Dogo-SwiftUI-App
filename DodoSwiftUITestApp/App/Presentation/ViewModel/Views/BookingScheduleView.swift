//
//  BookingScheduleView.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 30/05/2024.
//

import SwiftUI

struct BookingScheduleView: View {
    
    @State var currentDate: Date = Date()
    @State var currentMonth = 0
    @State var startTimeSelection: String? = nil
    @State var endTimeSelection: String? = nil
    @State var sitterSelection: String? = nil
    @State var maxWidth: CGFloat = 171
    @State var maxWidthForName: CGFloat = 358
    @State var clockIconName: String = "clock.circle"
    @State var personIconName: String = "person.circle"
    @State var startTimePlaceholder: String = "Select Start Time"
    @State var endTimePlaceholder: String = "Select End Time"
    @State var sitterPlaceholder: String = "Select your preffered Dog Sitter"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToThankYouView = false
    @State private var progress: Int = 0
    @State private var startTimeExpanded = false
    @State private var endTimeExpanded = false
    @State private var sitterExpanded = false
    
    @ObservedObject var viewModel = BookingScheduleViewModel()
    
    @State private var dogSitters: [String] = [""]
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                NavigationHeader(viewName: BookingView(presentSideMenu: .constant(true)))
                
                VStack(spacing: 16) {
                    HStack {
                        DateView(text: "Select the date")
                        Spacer()
                    }
                    VStack(spacing: 16) {
                        CalendarView(currentMonth: $currentMonth, currentDate: $currentDate)
                        DividerView(padding: 0)
                        CustomDatePicker(currentDate: $currentDate, currentMonth: $currentMonth)
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("menuShadowColor"), lineWidth: 1)
                            .shadow(radius: 5)
                    }
                }
                VStack {
                    ZStack(alignment: .bottom){
                        VStack {
                            ZStack {
                                if progress >= 1 {
                                    VStack(spacing: 0) {
                                        HStack {
                                            DateView(text: "Select the time")
                                            Spacer()
                                        }
                                        HStack(spacing: -20) {
                                            DropDownView(selection: $startTimeSelection, isExpanded: $startTimeExpanded, iconName: $clockIconName, dropDownPlaceholder: $startTimePlaceholder, maxWidth: $maxWidth, time: .constant(true), options: viewModel.getTimeArray())
                                                .padding(.leading, -12)
                                            DropDownView(selection: $endTimeSelection, isExpanded: $endTimeExpanded, iconName: $clockIconName, dropDownPlaceholder: $endTimePlaceholder, maxWidth: $maxWidth, time: .constant(true), options: viewModel.getTimeArray())
                                                .padding(.trailing, -12)
                                        }
                                    }
                                    .padding(.bottom, -10)
                                } else {
                                    VStack(spacing: 0) {
                                        HStack {
                                            DateView(text: "Select the time")
                                            Spacer()
                                        }
                                        HStack(spacing: -20) {
                                            VStack {
                                                DropDownView(selection: $startTimeSelection, isExpanded: $startTimeExpanded, iconName: $clockIconName, dropDownPlaceholder: $startTimePlaceholder, maxWidth: $maxWidth, time: .constant(true), options: viewModel.getTimeArray())
                                                    .padding(.leading, -12)
                                                Spacer()
                                            }
                                            VStack {
                                                DropDownView(selection: $endTimeSelection, isExpanded: $endTimeExpanded, iconName: $clockIconName, dropDownPlaceholder: $endTimePlaceholder, maxWidth: $maxWidth, time: .constant(true), options: viewModel.getTimeArray())
                                                    .padding(.leading, -12)
                                                Spacer()
                                            }
                                        }
                                    }
                                    .padding(.bottom, -10)
                                    .hidden()
                                }
                            }
                            .zIndex(progress >= 1 ? 1 : 0)
                            
                            if progress >= 2 {
                                VStack(spacing: 0) {
                                    HStack {
                                        DateView(text: "Select the dog sitter")
                                        Spacer()
                                    }
                                    HStack {
                                        VStack {
                                            DropDownView(selection: $sitterSelection, isExpanded: $sitterExpanded, iconName: $personIconName, dropDownPlaceholder: $sitterPlaceholder, maxWidth: $maxWidthForName, time: .constant(false), options: viewModel.dogSittersName)
                                                .padding(.horizontal, -14)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.bottom, -30)
                            } else {
                                VStack(spacing: 0) {
                                    HStack {
                                        DateView(text: "Select the dog sitter")
                                        Spacer()
                                    }
                                    HStack {
                                        VStack {
                                            DropDownView(selection: $sitterSelection, isExpanded: $sitterExpanded, iconName: $personIconName, dropDownPlaceholder: $sitterPlaceholder, maxWidth: $maxWidthForName, time: .constant(false), options: viewModel.dogSittersName)
                                                .padding(.horizontal, -14)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.bottom, -30)
                                .hidden()
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 80)
                        .zIndex(1)
                        
                        VStack {
                            NavigationLink(destination: ThankyouView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true),
                                           isActive: $navigateToThankYouView) {
                                EmptyView()
                            }
                                           .hidden()
                            Spacer()
                            Button(action: {
                                if progress < 2 {
                                    progress += 1
                                }
                                else {
                                    viewModel.saveBooking(startTimeSelection: startTimeSelection, endTimeSelection: endTimeSelection, sitterSelection: sitterSelection, currentDate: currentDate) { Bool, error in
                                        if let error = error {
                                            self.showAlert = true
                                            self.alertMessage = "\(error)"
                                        } else {
                                            print(currentDate)
                                            viewModel.scheduleNotification(startTimeSelection: startTimeSelection, currentDate: currentDate)
                                            navigateToThankYouView = true
                                        }
                                    }
                                }
                            }) {
                                textView(text: "Next", font: "Poppins-Regular", fontSize: 24, color: "white")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color("buttonColor"))
                                    .cornerRadius(8)
                            }
                            .offset(y: -16)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Unable to Book"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                        }
                        .zIndex(-1)
                    }
                }
            }
            .padding(.horizontal, 24)
            .background(Color("white"))
            .padding(.top, 10)
            .task {
                viewModel.fetchData()
            }
        }
    }
}

struct DateView: View {
    @State var text: String
    var body: some View {
        VStack() {
            textView(text: text, font: "Poppins-SemiBold", fontSize: 16, color: "blackColor")
        }
    }
}

struct CalendarView: View {
    @Binding var currentMonth: Int
    @Binding var currentDate: Date
    @ObservedObject var viewModel: CalendarViewModel = CalendarViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    currentMonth -= 1
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("blackColor"))
                })
                Spacer()
                textView(text: viewModel.formattedDate(currentDate: currentDate)[0] , font: "Poppins-Medium", fontSize: 18, color: "blackColor")
                Spacer()
                Button(action: {
                    currentMonth += 1
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("blackColor"))
                })
            }
        }
    }
}

#Preview {
    BookingScheduleView()
}
