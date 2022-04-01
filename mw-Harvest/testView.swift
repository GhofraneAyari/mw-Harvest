//
//  testView.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 29/03/2022.
//

import SwiftUI

struct testView: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace private var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            //Lazy stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    // Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10){
                            
                            ForEach(taskModel.currentWeek,id: \.self){day in
                                
                                VStack(spacing: 10){
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                
                                //EEE return da as MON, TUE ...
                                Text(taskModel.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 14))
                                    
                                Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                
                                
                                }
                                //Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                
                                //Capsule shape
                                .frame(width: 45, height: 90)
                                .background(
                                    
                                    ZStack{
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    //Updating Cureent Day
                                    withAnimation {
                                        taskModel.currentDate = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                } header: {
                    HeaderView()
                    
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    //Tasks View
    func TasksView()->some View {
        
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
    
    //Task card View
    func TaskCardView(task: Task)->some View{
        
        HStack{
            VStack(spacing: 10) {
                Circle()
                    .fill(.black)
                    .frame(width: 15, height: 15)
                    .background(
                    Circle()
                        .stroke(.black,lineWidth:  1)
                        .padding(-3)
                    )
                
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
            }
            .foregroundColor(.white)
            .padding()
            .hLeading()
            .background(
                Color("Black")
                    .cornerRadius(25)
            )
        }
        .hLeading()
    }
}



// Header

func HeaderView()->some View {
    
    HStack(spacing: 220){
        
        VStack(alignment: .leading, spacing: 10
        ) {
            
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .foregroundColor(.gray)
            
            Text("Today")
                .font(.largeTitle.bold())
            
        }
        .hLeading()
        
        
        Button {
            
        } label: {
            Image("profilpic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .shadow(radius: 25)
                
            
        }
        
    }
    .padding()
    .padding(.top,getSafeArea().top)
    .background(Color.white)
    
    
    
}

func getSafeArea()->UIEdgeInsets {
    
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return .zero
    }
    
    guard let safeArea = screen.windows.first?.safeAreaInsets else {
        return .zero
    }
    return safeArea
}


struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}


// UI Design Helper Functions
extension View {
    
    func hLeading()->some View{
        self
            .frame(width: .infinity,alignment: .leading)
        
    }
    
    func hTrailing()-> some View{
        self
            .frame(width: .infinity,alignment: .trailing)
    }
    
    func hCenter()-> some View{
        self
            .frame(width: .infinity,alignment: .center
            )
    }
    
    // Safe Area
    
   
}



