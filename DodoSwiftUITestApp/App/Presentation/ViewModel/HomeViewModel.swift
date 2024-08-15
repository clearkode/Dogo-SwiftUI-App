//
//  HomeViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 04/06/2024.
//

import Foundation
import FirebaseFirestoreInternal

class HomeViewModel: ObservableObject {
    @Published var dogSitters : [DogSitterModel] = []
    @Published var isLoading: Bool = true
    @Published var recentBooking: BookingModel?
    @Published var dogSitterImage: String = ""
    
    private var hasFetchedData: Bool = false
    
    func fetchData() {
        guard !hasFetchedData else { return }
        isLoading = true
        LogService.log("Fetch: Start")
        AuthManager.db
            .collection("dogsitters")
            .getDocuments { (snapshot, error) in
                defer { self.isLoading = false }
                guard let snapshot = snapshot, error == nil else {
                    return
                }
                LogService.log("Number of documents: \(snapshot.documents.count )")
                self.dogSitters = snapshot.documents.compactMap { documentSnapshot -> DogSitterModel? in
                    let documentData = documentSnapshot.data()
                    if let name = documentData["name"] as? String, let rating = documentData["rating"] as? Int, let charges = documentData["charges"] as? Int, let profile = documentData["profile"] as? String, let tours = documentData["tours"] as? Int {
                        self.isLoading = false
                        LogService.log("Fetch: Successfull")
                        return DogSitterModel(name: name, rating: rating, charges: charges, profile: profile, tours: tours)
                    } else {
                        LogService.log("Fetch: Unsuccessfull")
                        return nil
                    }
                }
                self.hasFetchedData = true
            }
    }
    
    func getRecentBooking() {
        guard let currentUser = AuthManager.auth.currentUser else { return }
        let userID = currentUser.uid
        AuthManager.db.collection("bookings")
            .whereField("userId", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    return
                }
                
                let sortedBookings = querySnapshot?.documents
                    .compactMap { document -> BookingModel? in
                        guard
                            let date = document["date"] as? Timestamp,
                            let startTime = document["startTime"] as? String,
                            let endTime = document["endTime"] as? String,
                            let sitter = document["sitter"] as? String,
                            let userId = document["userId"] as? String
                        else {
                            return nil
                        }
                        
                        return BookingModel(date: date, startTime: startTime, endTime: endTime, sitter: sitter, userId: userId)
                    }
                    .sorted { $0.startTime > $1.startTime }
                
                if let mostRecentBooking = sortedBookings?.first {
                    self.recentBooking = mostRecentBooking
                } else {
                    self.recentBooking = nil
                }
            }
    }
    
    func fetchDogSitterImage() {
        AuthManager.db.collection("dogsitters")
            .whereField("name", isEqualTo: self.recentBooking?.sitter ?? "Emily T")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    LogService.log("Error fetching dog sitter image: \(error)")
                    return
                }
                
                if let document = querySnapshot?.documents.first {
                    if let imageURL = document["profile"] as? String {
                        self.dogSitterImage = imageURL
                    } else {
                        LogService.log("Image URL not found for \(self.recentBooking?.sitter ?? "Emily T")")
                    }
                } else {
                    LogService.log("No dog sitter found with name: \(self.recentBooking?.sitter ?? "Emily T")")
                }
            }
    }
    
    func extraDate(timestamp: Timestamp) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        
        let date = formatter.string(from: timestamp.dateValue())
        
        return date.components(separatedBy: " ")
    }
    
}
