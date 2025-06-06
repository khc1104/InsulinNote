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
    @Query var settings: [InsulinSettingModel]
    
    @State var longActingInsulinSetting: InsulinSettingModel?
    @State var fastActingInsulinSetting: InsulinSettingModel?
    
    @State var longActingInsulinLogs: [InsulinRecordModel] = []
    @State var fastActingInsulinLogs: [InsulinRecordModel] = []
    var body: some View {
        VStack(alignment: .leading){
            Text("\(longActingInsulinSetting?.insulinProductName ?? "지효성 인슐린")")
                .font(.title)
                .padding(.top, 5)
                .padding(.leading, 20)
            VStack{
                List{
                    if let longActingInsulinLog = longActingInsulinLogs.first{
                        VStack(alignment: .leading){
                            Text("투여시간: \(longActingInsulinLog.createdAt.formatted(.dateTime))")
                            Text("투여량: \(longActingInsulinLog.dosage)")
                        }
                    }
                }
            }
            Text("\(fastActingInsulinSetting?.insulinProductName ?? "속효성 인슐린")")
                .font(.title)
                .padding(.leading, 20)
            List{
                ForEach(fastActingInsulinLogs){ fastActingInsulinLog in
                    VStack(alignment: .leading){
                        Text("투여시간: \(fastActingInsulinLog.createdAt.formatted(.dateTime))")
                        Text("투여량: \(fastActingInsulinLog.dosage)")
                    }
                }
            }
        }.onAppear{
            longActingInsulinSetting = settings.first(where: {$0.actingType == .long})
            fastActingInsulinSetting = settings.first(where: {$0.actingType == .fast})
            longActingInsulinLogs = getInsulinLogsForActType(type: .long)
            fastActingInsulinLogs = getInsulinLogsForActType(type: .fast)
        }
    }
    //인슐린 기록 불러오는 함수
    func getInsulinLogsForActType(type: InsulinSettingModel.ActingType) -> [InsulinRecordModel] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filteredRecords = records.filter{
            let recordDate = formatter.string(from: $0.createdAt)
            if recordDate == selectedDate && $0.setting?.actingType == type {
                return true
            }else{
                return false
            }
        }
        
        return filteredRecords
    }
}

//#Preview {
//    RecordCalendarLogView()
//}
