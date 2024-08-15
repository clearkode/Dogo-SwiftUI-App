//
//  BookingModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 05/06/2024.
//

import Foundation
import FirebaseFirestoreInternal

struct BookingModel {
    var id = UUID()
    var date : Timestamp
    var startTime: String
    var endTime: String
    var sitter: String
    var userId: String
}
