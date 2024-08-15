//
//  BookingViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 08/06/2024.
//

import Foundation
import FirebaseFirestoreInternal

class BookingViewModel: ObservableObject {
    
    @Published var booking : [BookingModel] = []
    @Published var noOfBooking: Int = 0
    @Published var isLoading: Bool = true
    
    var groupedBookings: [String: [BookingModel]] {
        var groupedDict: [String: [BookingModel]] = [:]
        
        for booking in self.booking {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let monthYearString = dateFormatter.string(from: booking.date.dateValue())
            
            if var bookingsForMonth = groupedDict[monthYearString] {
                bookingsForMonth.append(booking)
                groupedDict[monthYearString] = bookingsForMonth
            } else {
                groupedDict[monthYearString] = [booking]
            }
        }
        
        return groupedDict
    }
    
    func fetchBookingData() {
        guard let currentUserUID = AuthManager.auth.currentUser?.uid else {
            LogService.log("User is not authenticated")
            print("User is not authenticated")
            return
        }
        LogService.log("Fetch booking start")
        isLoading = true
        AuthManager.db
            .collection("bookings")
            .whereField("userId", isEqualTo: currentUserUID)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                defer {
                    self.isLoading = false
                }
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    LogService.log("Error getting booking document")
                    return
                }
                print("Number of documents: \(snapshot.documents.count )")
                self.noOfBooking = snapshot.documents.count
                LogService.log("Number of booking documents: \(snapshot.documents.count )")
                self.booking = snapshot.documents.compactMap { documentSnapshot -> BookingModel? in
                    let documentData = documentSnapshot.data()
                    if let date = documentData["date"] as? Timestamp,
                       let startTime = documentData["startTime"] as? String,
                       let endTime = documentData["endTime"] as? String,
                       let sitter = documentData["sitter"] as? String,
                       let userId = documentData["userId"] as? String
                    {
                        self.isLoading = false
                        LogService.log("Booing fetch Successfull")
                        return BookingModel(date: date, startTime: startTime, endTime: endTime, sitter: sitter, userId: userId)
                    } else {
                        LogService.log("Booing fetch Unsuccessfull")
                        return nil
                    }
                }
            }
    }
}
