//
//  LockScreenInfoWidget.swift
//  InsulinNote
//
//  Created by 권희철 on 9/18/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct LockScreenInfoTimeLineProvider: TimelineProvider{
    func placeholder(in context: Context) -> InsulinInfoTimeLineEntry {
        InsulinInfoTimeLineEntry(date: .now)
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (InsulinInfoTimeLineEntry) -> Void) {
        return
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<InsulinInfoTimeLineEntry>) -> Void) {
//        let modelContext = ModelContextStore.sharedModelContext
//        
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: Date())
//        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//        
//        let descriptor = FetchDescriptor<InsulinRecordModel>(
//            predicate: #Predicate { $0.createdAt > startOfDay && $0.createdAt < startOfTomorrow },
//            sortBy: [.init(\.createdAt)]
//        )
//        do{
//            let todayRecords = try modelContext.fetch(descriptor)
//            let lastLongActingInjection = todayRecords.last(where: { $0.setting?.actingType == .long })
//            let lastFastActingInjection = todayRecords.last(where: { $0.setting?.actingType == .fast })
//            let entry = InsulinInfoTimeLineEntry(date: .now, lastLongActingRecord: lastLongActingInjection, lastFastActingRecord: lastFastActingInjection)
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
//            return
//        }catch{
//            print("cant fetch insulin record")
//        }
        let entry = InsulinInfoTimeLineEntry(date: Date())
        let timeLine = Timeline(entries: [entry], policy: .never)
        completion(timeLine)
        return
    }
}

struct InsulinInfoTimeLineEntry: TimelineEntry{
    var date: Date
    var lastLongActingRecord: InsulinRecordModel?
    var lastFastActingRecord: InsulinRecordModel?
}

struct LockScreenInfoWidget: Widget{
    let kind: String = "LockScreenInfoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider:
                                LockScreenInfoTimeLineProvider()){entry in
            LockScreenInfoView()
                .modelContainer(for: [InsulinSettingModel.self])
        }
                                .configurationDisplayName("인슐린 투여")
                                .description("인슐린 투여를 더 빠르게 기록하세요")
                                .supportedFamilies([.accessoryRectangular])
    }
}
