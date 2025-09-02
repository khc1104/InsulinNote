//
//  RecordingWidget.swift
//  RecordingWidget
//
//  Created by 권희철 on 8/13/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct RecordProvider: AppIntentTimelineProvider{
    func placeholder(in context: Context) -> RecordingEntry {
        return RecordingEntry(
            date: .now,
            setting: RecordingEntity(id: UUID(),
                                     insulinSetting:
                                        InsulinSettingModel(
                                            insulinProductName: "none", actingType: .fast,
                                            dosage: 99,
                                            records: [],
                                            updatedAt: .now))
            )
    }
    
//    func timeline(for configuration: RecordingConfigurationIntent, in context: Context) async -> Timeline<RecordingEntry> {
//        let entry = RecordingEntry(
//            date: .now,
//            setting: configuration.setting
//        )
//            let timeLine = Timeline(entries: [entry], policy: .never)
//        return timeLine
//    }
    func timeline(for configuration: RecordingConfigurationIntent, in context: Context) async -> Timeline<RecordingEntry> {
        let now = Date()
        let calendar = Calendar.current
        // 오늘의 날짜에서 다음 자정(내일 0시) 계산
        guard let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .strict) else {
            // fallback: 업데이트 없이 현재 상태만 반환
            let entry = RecordingEntry(date: now, setting: configuration.setting)
            return Timeline(entries: [entry], policy: .never)
        }
        
        let currentEntry = RecordingEntry(date: now, setting: configuration.setting)
        let midnightEntry = RecordingEntry(date: nextMidnight, setting: configuration.setting)
        // .atEnd: 마지막 엔트리의 날짜에 도달하면 다시 timeline이 호출됨
        return Timeline(entries: [currentEntry, midnightEntry], policy: .atEnd)
    }

    func snapshot(for configuration: RecordingConfigurationIntent, in context: Context) async -> RecordingEntry {
        return RecordingEntry(
            date: .now,
            setting: configuration.setting
        )
    }
    
}

struct  RecordingEntry: TimelineEntry {
    let date: Date
    let setting: RecordingEntity

}


struct RecordingWidget: Widget {
    let kind: String = "RecordingWidget"
    
    var body: some WidgetConfiguration{
        AppIntentConfiguration(
            kind: kind,
            intent: RecordingConfigurationIntent.self,
            provider: RecordProvider()) { entry in
                RecordingWidgetEntryView(entry: entry)
                    .modelContainer(for: [InsulinSettingModel.self])
            }
            .configurationDisplayName("insulin Recording Display")
            .description("인슐린 설명")
            .supportedFamilies([.accessoryCircular, .systemSmall])
    }
}

struct RecordingConfigurationIntent: WidgetConfigurationIntent{
    static var title: LocalizedStringResource = "인슐린 세팅"
    static var description = IntentDescription("Selects the character to display information for.")

    
    @Parameter(title: "productName")
    var setting: RecordingEntity
    
    init(setting: RecordingEntity) {
        self.setting = setting
    }
    init() {
        
    }
}
