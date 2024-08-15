//
//  BookingScheduleViewModel.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 05/06/2024.
//

import Foundation
import UserNotifications
import FirebaseFirestoreInternal

class BookingScheduleViewModel: ObservableObject {
    
    @Published var dogSittersName : [String] = []
    @Published var startTime: String = ""
    
    func fetchData() {
        LogService.log("Fetch: Start")
        AuthManager.db
            .collection("dogsitters")
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    return
                }
                self.dogSittersName = snapshot.documents.compactMap { documentSnapshot -> String? in
                    let documentData = documentSnapshot.data()
                    if let name = documentData["name"] as? String {
                        LogService.log("Fetch: Successfull")
                        return name
                    } else {
                        LogService.log("Fetch: Unsuccessfull")
                        return nil
                    }
                }
            }
    }
    
    func saveBooking(startTimeSelection: String?, endTimeSelection: String?, sitterSelection: String?, currentDate: Date, complete: @escaping(Bool, Error?) -> Void) {
        guard let startTime = startTimeSelection,
              let endTime = endTimeSelection,
              let sitter = sitterSelection
        else {
            LogService.log("Booking data incomplete")
            complete(false, "Booking data incomplete")
            return
        }
        
        guard startTime != endTime else {
            LogService.log("Start Time and End Time Can't be the same!")
            complete(false, "Start Time and End Time Can't be the same")
            return
        }
        
        let calendar = Calendar.current
        
        guard let currentUser = AuthManager.auth.currentUser else {
            LogService.log("User is not authenticated")
            return
        }
        let userID = currentUser.uid
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard var currentDate = formatter.date(from: formatter.string(from: currentDate)) else {
            LogService.log("Error: Invalid current date")
            return
        }
        
        let currentDateTimestamp = Timestamp(date: currentDate)
        
        AuthManager.db.collection("bookings")
            .whereField("userId", isEqualTo: userID)
            .whereField("date", isEqualTo: currentDateTimestamp)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    LogService.log("Error querying bookings: \(error)")
                    complete(false, error)
                    return
                }
                
                LogService.log("Number of documents: \(querySnapshot?.documents.count ?? 0 )")
                
                if let documents = querySnapshot?.documents {
                    let overlappingBookings = documents.filter { document in
                        let bookingStartTime = document["startTime"] as? String ?? ""
                        let bookingEndTime = document["endTime"] as? String ?? ""
                        return (bookingStartTime < endTime) && (bookingEndTime > startTime)
                    }
                    
                    if !overlappingBookings.isEmpty {
                        LogService.log("This slot is already Booked! Choose Another slot!")
                        complete(false, "This slot is already Booked! Choose Another slot!")
                        return
                    }
                }
                
                let bookingData: [String: Any] = [
                    "date": currentDateTimestamp,
                    "startTime": startTime,
                    "endTime": endTime,
                    "sitter": sitter,
                    "userId" : userID
                ]
                
                AuthManager.db.collection("bookings").addDocument(data: bookingData) { error in
                    if let error = error {
                        LogService.log("Error adding document: \(error)")
                        complete(false, error)
                    } else {
                        LogService.log("Booking added successfully")
                        self.askForPermission()
                        complete(true, nil)
                    }
                }
            }
    }
    
    func askForPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                LogService.log("Notification permission granted.")
            } else if let error = error {
                LogService.log("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(startTimeSelection: String?, currentDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Dogo"
        content.subtitle = "Your dog sitter is coming!"
        content.sound = UNNotificationSound.default
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let startTimeSelection = startTimeSelection,
              var currentDate = formatter.date(from: formatter.string(from: currentDate)) else {
            LogService.log("Error: Invalid start time selection or current date")
            return
        }
        guard let selectedTime = formatter.date(from: "2000-01-01 \(startTimeSelection)") else {
            LogService.log("Error: Unable to parse selected time")
            return
        }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(currentDate) {
            currentDate = formatter.date(from: formatter.string(from: currentDate))!
        } else {
            if let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = tomorrowDate
            } else {
                LogService.log("Error: Unable to get date")
                return
            }
        }
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        guard let selectedHour = timeComponents.hour, let selectedMinute = timeComponents.minute else {
            LogService.log("Error: Unable to extract hour and minute from selected time")
            return
        }
        
        let notificationHour = selectedHour - 1
        var notificationMinute = selectedMinute + 45
        var notificationDay = dateComponents.day ?? 0
        let notificationMonth = dateComponents.month ?? 0
        let notificationYear = dateComponents.year ?? 0
        
        if notificationMinute < 0 {
            notificationDay -= 1
            notificationDay = max(notificationDay, 1)
            notificationMinute += 60
        }
        
        let triggerDateComponents = DateComponents(year: notificationYear, month: notificationMonth, day: notificationDay, hour: notificationHour, minute: notificationMinute)
        
        guard let triggerDate = calendar.date(from: triggerDateComponents) else {
            LogService.log("Error: Unable to create trigger date")
            return
        }
        
        if triggerDate < Date.now {
            LogService.log("Error: Trigger date is in the past")
            return
        }
        
        // Set the notification trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        // Choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add our notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                LogService.log("Error scheduling notification: \(error.localizedDescription)")
            } else {
                LogService.log("Notification scheduled successfully")
            }
        }
    }
    
    func getTimeArray() -> [String] {
        let lastTime: Double = 23
        var currentTime: Double = 0
        let incrementMinutes: Double = 60
        var timeArray: [String] = []
        while currentTime <= lastTime {
            currentTime += (incrementMinutes/60)
            let hours = Int(floor(currentTime))
            let minutes = Int(currentTime.truncatingRemainder(dividingBy: 1)*60)
            if minutes == 0 {
                timeArray.append("\(hours):00")
            } else {
                timeArray.append("\(hours):\(minutes)")
            }
        }
        return timeArray
    }
    
}
