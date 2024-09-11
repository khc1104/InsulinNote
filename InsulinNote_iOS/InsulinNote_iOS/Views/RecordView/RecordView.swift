//
//  RecordView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/9/24.
//

import SwiftUI
import SwiftData

struct RecordView:View {
    @State var date: Date = .now
    @State var isInjected: Bool = false
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    var longActingInsulin: InsulinSettingModel? {
        insulinSettings.filter{
            $0.actingType == .long
        }.first
    }
    
    var fastActingInsulin: InsulinSettingModel? {
        insulinSettings.filter{
            $0.actingType == .fast
        }.first
    }
    
    var today: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy년 M월 d일 E"
        return formatter.string(from: date)
    }
    
    var body: some View {
        GeometryReader{proxy in
            VStack(alignment: .leading, spacing: 10){
                Text("\(today)")
                    .font(.largeTitle)
                LongActingInsulinView(
                    insulingSetting: longActingInsulin,
                    proxy: proxy,
                    isInjected: $isInjected)
                FastActingInsulinView(insulinSetting: fastActingInsulin)
                Button{
                    
                }label: {
                    ZStack{
                        Rectangle()
                            .frame(width: proxy.size.width - 20, height: 50)
                            .foregroundStyle(.clear)
                            .border(Color.black, width: 1)
                        Text("투여")
                            .font(.title3)
                    }
                }
                
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview{
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InsulinSettingModel.self
                                        , configurations: config)

    let insulin1 = InsulinSettingModel(insulinProductName: "트레시바", actingType: .long, dosage: 22, records: [
        InsulinRecordModel(dosage: 22, createdAt: .now, updatedAt: .now)
    ], updatedAt: .now)
    container.mainContext.insert(insulin1)
    
    let insulin2 = InsulinSettingModel(insulinProductName: "노보래피드", actingType: .fast, dosage: 17, records: [
        InsulinRecordModel(dosage: 17, createdAt: .now, updatedAt: .now)
    ], updatedAt: .now)
    container.mainContext.insert(insulin2)
    
    
    
    return RecordView().modelContainer(container)
    
}
