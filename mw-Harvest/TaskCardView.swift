//
//  TaskCardView.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 30/03/2022.
//

import SwiftUI

struct TaskCardView: View {
    var task: Task
    var body: some View {
        HStack {
            VStack(spacing: 10) {
                Circle()
                    .fill(.black)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
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

// struct TaskCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCardView()
//    }
// }
