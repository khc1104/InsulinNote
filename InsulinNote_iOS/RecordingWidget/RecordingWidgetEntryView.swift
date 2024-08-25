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
            Text(insulinSettings.first?.insulinProductName ?? "insulinName")
                .font(.largeTitle)
            HStack{
                Text(insulinSettings.first?.records?.first?.createdAt ?? .now, style: .relative)
                    .multilineTextAlignment(.trailing)
                Text("전")
                
            }
            Button(intent: RecodingIntent()) {
                Image(systemName: "syringe")
            }.buttonStyle(.borderedProminent)
            
            Toggle(isOn: false ,intent: RecodingIntent()) { //CustomToggleStyle 만들 수 있음
                Image(systemName: "syringe")
            }
            
        }
    }
}
