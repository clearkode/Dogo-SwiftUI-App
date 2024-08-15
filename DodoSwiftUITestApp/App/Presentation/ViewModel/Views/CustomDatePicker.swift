//
//  CustomDatePicker.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 31/05/2024.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var currentDate: Date
    @Binding var currentMonth: Int
    @ObservedObject var viewModel = CustomDatePickerViewModel()
    
    var body: some View {
        
        let days : [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        VStack {
            LazyVGrid(columns: columns, spacing: 15, content: {
                ForEach(days, id: \.self) { day in
                    textView(text: day, font: "Poppins-Medium", fontSize: 12, color: "blackColor")
                }
            })
        }
        VStack(spacing: 16) {
            LazyVGrid(columns: columns, spacing: 15, content: {
                ForEach(extractDate()) { value in
                    cardView(value: value)
                        .background(
                            Circle()
                                .fill(value.day != -1 ? Color("yellowColor") : .white)
                                .frame(width: 42, height: 42)
                                .opacity(viewModel.isSameDate(date1: value.date, date2: currentDate) ? 1: 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            })
        }
        .frame(height: viewModel.calculateViewHeight())
        .onChange(of: currentMonth) { _ in
            currentDate = getCurrentMonth()
        }
        
    }
    
    @ViewBuilder
    func cardView(value: DateValue)-> some View {
        VStack {
            if value.day != -1 {
                textView(text: "\(value.day)", font: "Poppins-Regular", fontSize: 20, color: "blackColor")
            }
        }
        .padding(.vertical, 8)
        .frame(height: 40, alignment: .top)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth
        
        var days = currentMonth().getAllDate().compactMap { date -> DateValue in
            //getting date
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        var offset = firstWeekday - 2
        if offset < 0 {
            offset += 7
        }
        for _ in 0..<offset {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}

#Preview {
    CustomDatePicker(currentDate: .constant(Date()), currentMonth: .constant(0))
}
