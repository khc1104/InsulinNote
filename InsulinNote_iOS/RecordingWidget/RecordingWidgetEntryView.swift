//
//  RecodingWidgetView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/25/24.
//

import SwiftUI
import SwiftData
import AppIntents

struct RecordingWidgetEntryView : View {
    var entry: RecordProvider.Entry
    @Environment(\.widgetFamily) var family
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    var formatter : DateFormatter{
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "M월 dd일"
        return format
    }
    
    var body: some View {
        VStack{
            switch family{
            case .accessoryCircular:
                ZStack{
                    if !getIsInjected(records: entry.setting.insulinSetting.records){
                        Button("\(entry.setting.insulinSetting.insulinProductName)", intent: RecordingIntent(id: entry.setting.insulinSetting.id.uuidString))
                    }else{
                        Text("맞음")
                    }
                }
            default:
                VStack(alignment: .leading) {
                    Text(entry.setting.insulinSetting.insulinProductName)
                        .font(.largeTitle)
                    Text("\(formatter.string(from: .now))")
                    Text("\(entry.setting.insulinSetting.dosage)단위")
                    if !getIsInjected(records: entry.setting.insulinSetting.records){
                        Toggle(isOn: false ,intent: RecordingIntent(id: entry.setting.insulinSetting.id.uuidString)) { //CustomToggleStyle 만들 수 있음
                            Image(systemName: "syringe")
                        }
                    }else{
                        Text("이미 맞음")
                    }
                    
                }
            }
        }.containerBackground(for: .widget){}
        
    }
    private func getIsInjected(records: [InsulinRecordModel]) -> Bool{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let strToday = formatter.string(from: today)
        
        let record =  records.filter{
            return formatter.string(from: $0.createdAt) == strToday
        }.sorted(by: {$0.createdAt > $1.createdAt})
        
        if record.isEmpty { return false } else { return true }
    }
}

#Preview {
    RecordingWidgetEntryView(entry: RecordingEntry.init(
        date: .now,
        setting: RecordingEntity.init(id: UUID.init(),
                                      insulinSetting:
                                        InsulinSettingModel(insulinProductName: "트레시바", actingType: .long,
                                                            dosage: 22,
                                                            records: [
                                                                InsulinRecordModel(dosage: 22, createdAt: .now, updatedAt: .now)
                                                            ],
                                                            updatedAt:
                                                .now)
                                     )
    )
    )
}
