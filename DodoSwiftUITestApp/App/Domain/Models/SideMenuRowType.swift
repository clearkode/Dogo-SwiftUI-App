//
//  SideMenuRowType.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 27/05/2024.
//

import Foundation

enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case booking
    case notifications
    case settings
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .booking:
            return "Bookings"
        case .notifications:
            return "Notifications"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .booking:
            return "booking"
        case .notifications:
            return "notification"
        case .settings:
            return "setting"
        }
    }
    
    var label: String {
        switch self {
        case .notifications:
            return "2"
        case .home:
            return ""
        case .booking:
            return ""
        case .settings:
            return ""
        }
    }
}
