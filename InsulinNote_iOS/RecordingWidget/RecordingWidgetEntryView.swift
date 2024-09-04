//
//  RecodingWidgetView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/25/24.
//

import SwiftUI
import SwiftData

struct RecordingWidgetEntryView : View {
    var entry: RecordProvider.Entry
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    var body: some View {
        VStack {
            Text(entry.setting.insulinSetting.insulinProductName)
                .font(.largeTitle)
            HStack{
                Text(entry.setting.insulinSetting.records.first?.createdAt ?? .now, style: .relative)
                    .multilineTextAlignment(.trailing)
                Text("전")
                
            }
            Text("\(entry.setting.insulinSetting.administration)단위")
            Toggle(isOn: false ,intent: RecordingIntent(id: entry.setting.insulinSetting.id.uuidString)) { //CustomToggleStyle 만들 수 있음
                Image(systemName: "syringe")
            }
            
        }
    }
}
