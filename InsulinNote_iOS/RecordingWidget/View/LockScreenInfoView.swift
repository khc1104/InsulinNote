//
//  LockScreenInfoView.swift
//  InsulinNote
//
//  Created by 권희철 on 9/18/25.
//

import SwiftUI
import SwiftData

struct LockScreenInfoView: View {
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    private var longActingSetting: InsulinSettingModel{
        insulinSettings.first(where: {$0.actingType == .long}) ?? InsulinSettingModel(insulinProductName: "지효성", actingType: .long, dosage: 20, records: [], updatedAt: .now)
    }
    private var fastActingSetting: InsulinSettingModel{
        insulinSettings.first(where: {$0.actingType == .fast}) ?? InsulinSettingModel(insulinProductName: "지효성", actingType: .fast, dosage: 20, records: [], updatedAt: .now)
    }
    
    

    var body: some View {
        VStack{
            HStack{
                Text("\(longActingSetting.insulinProductName)")
                Spacer()
                Text("\(getLastInjected(records: longActingSetting.records))")
            }
            HStack{
                Text("\(fastActingSetting.insulinProductName)")
                Spacer()
                Text("\(getLastInjected(records: fastActingSetting.records))")
            }
        }
    }
    
    private func getLastInjected(records: [InsulinRecordModel]) -> String {
        let dateFormatter: DateFormatter = {  //날짜 비교용
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        let timeFormmatter: DateFormatter = {  //리턴할 때 사용
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        let lastInjectedRecord = records.filter {
            let today = dateFormatter.string(from: .now)
            let recordDate = dateFormatter.string(from: $0.createdAt)
            return today == recordDate
        }.sorted { $0.createdAt > $1.createdAt }

        if let record = lastInjectedRecord.first {
            return timeFormmatter.string(from: record.createdAt)
        } else {
            return "오늘 기록 없음"
        }
    }
}

