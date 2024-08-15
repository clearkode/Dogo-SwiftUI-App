//
//  CustomDatePickerViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 30/06/2024.
//

import Foundation

class CustomDatePickerViewModel: ObservableObject {
    
    func isSameDate(date1: Date, date2: Date)-> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func calculateViewHeight() -> CGFloat {
        let numberOfWeeks = 6
        let rowHeight: CGFloat = 47
        return CGFloat(numberOfWeeks) * rowHeight
    }
}
