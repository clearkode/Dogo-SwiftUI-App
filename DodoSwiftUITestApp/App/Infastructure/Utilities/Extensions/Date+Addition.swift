//
//  Date+Addition.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 30/06/2024.
//

import Foundation

extension Date {
    func getAllDate() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))
        let range = calendar.range(of: .day, in: .month, for: startDate ?? self)
        return range?.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate ?? self) ?? Date.now
        } ?? []
    }
}
