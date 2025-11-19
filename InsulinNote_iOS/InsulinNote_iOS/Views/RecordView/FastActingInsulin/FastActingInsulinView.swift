//
//  fastActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/9/24.
//

import SwiftUI
import SwiftData

struct FastActingInsulinView:View {
    @Environment(\.modelContext) var insulinContext

    let date: Date
    let setting: InsulinSettingModel?
    let onButtonTapped: () -> Void
    
    private var todayRecords: [InsulinRecordModel]{
        if let setting{
            let calendar = Calendar.current
            return setting.records.filter{
                calendar.isDateInToday($0.createdAt)
            }.sorted(by: {$0.createdAt > $1.createdAt})
        }else{
            return []
        }
    }
    
    var body: some View {
        if let setting{
            VStack(alignment: .leading){
                Text(setting.insulinProductName)
                    .font(.title)
                    .foregroundStyle(Color.fastActing)
                ScrollView(.horizontal){
                    HStack(spacing: 0){
                        ForEach(todayRecords){ record in
                            FastActingInsulinRecordCardView(insulinRecord: record)
                                .padding(.leading, todayRecords.first == record ? 15 : 0)
                                .padding(.trailing, 15)
                                .padding(.vertical, 15)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color.fastActing, width: 1)
                .scrollIndicators(.hidden)
                
            }
            Button{
                onButtonTapped()
            }label: {
                ZStack{
                    Rectangle()
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .foregroundStyle(.clear)
                        .border(Color.fastActing, width: 1)
                    Text("투여")
                        .font(.title3)
                }
            }
        }
    }
}

