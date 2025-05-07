//
//  RecordCalendarLogView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 5/8/25.
//

import SwiftUI
import SwiftData

struct RecordCalendarLogView: View {
    
    var selectedDate: String
    
    @Environment(\.modelContext) var insulinContext
    @Query var records: [InsulinRecordModel]
    
    var body: some View {
        List {
            ForEach(getInsulinLogsForActType(type: .long)){ log in
                VStack{
                    Text("이름: \(log.setting?.insulinProductName ?? "미지정")")
                    Text("투여시간: \(log.createdAt.formatted(.dateTime))")
                    Text("투여량: \(log.dosage)")
                }
            }
        }
    }
    //인슐린 기록 불러오는 함수
    func getInsulinLogsForActType(type: InsulinSettingModel.ActingType) -> [InsulinRecordModel] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filteredRecords = records.filter{
            let recordDate = formatter.string(from: $0.createdAt)
            return recordDate == selectedDate
        }
        
        return filteredRecords
    }
}

//#Preview {
//    RecordCalendarLogView()
//}
