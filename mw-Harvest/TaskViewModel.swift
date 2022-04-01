//
//  TaskViewModel.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 28/03/2022.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject{
    
    //Sample Tasks
    @Published var storedTasks: [Task] = [
        
        Task(taskTitle: "Accounting", taskDescription: "Delivered company invoices", taskDate: .init(timeIntervalSince1970: 1648722445)),
        Task(taskTitle: "Programming", taskDescription: "Internal App development", taskDate: .init(timeIntervalSince1970: 1648722445)),
        Task(taskTitle: "HR", taskDescription: "Hiring", taskDate: .init(timeIntervalSince1970: 1648722445)),
        Task(taskTitle: "Communication", taskDescription: "Communication with a client", taskDate: .init(timeIntervalSince1970: 1648722445)),
    ]
    

    
    // Current Week Days
    @Published var currentWeek: [Date] = []
    
    // Current Day
    @Published var currentDate: Date = Date()
    
    //Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    //Initializing
    init(){
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    //Filter Today Tasks
    func filterTodayTasks(){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter{
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDate)
            }
            
            DispatchQueue.main.async {
                withAnimation{
                    self.filteredTasks = filtered
                }
            }
            
        }
    }
    
    func fetchCurrentWeek(){
        
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    
    
    // Extracting Date
    func extractDate(date: Date,format: String)-> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    //Check if current date is today
    
    func isToday(date: Date)->Bool{
        
        let calendar = Calendar.current
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
}
        
