//
//  TaskView.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/03/2022.
//

import SwiftUI

struct TaskView: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    var body: some View {
        LazyVStack(spacing: 18){
            
            if let tasks = taskModel.filteredTasks {
                
                if tasks.isEmpty{
                
                    Text("No timesheet found!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }
                else{
                    ForEach(tasks){task in
                        
                        
                    }
                }
            }
            else{
                //Progress View
                ProgressView()
                    .offset(y: 180)
            }
            
        }
        .padding()
        .padding(.top)
        
        //Updating Tasks
        .onChange(of: taskModel.currentDate) { newValue in
            taskModel.filterTodayTasks()
        }
    }
    
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
