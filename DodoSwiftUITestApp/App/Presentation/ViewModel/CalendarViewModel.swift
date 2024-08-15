//
//  CalendarViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 30/06/2024.
//

import Foundation

class CalendarViewModel: ObservableObject {
    
    func formattedDate(currentDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        let dateStr = formatter.string(from: currentDate)
        return dateStr.components(separatedBy: " ")
    }
    
}
