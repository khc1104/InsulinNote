//
//  RecordingWidget.swift
//  RecordingWidget
//
//  Created by 권희철 on 8/13/24.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct RecordingEntry: TimelineEntry {
    let date: Date
    let settingId: UUID
    let productName: String
    let dosage: Int
    let actingType: InsulinSettingModel.ActingType
    let lastRecordDate: Date?
    let lastRecordDosage: Int?
}

struct RecordProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> RecordingEntry {
        RecordingEntry(date: .now,
                       settingId: UUID(),
                       productName: "지효성",
                       dosage: 99,
                       actingType: .long,
                       lastRecordDate: nil,
                       lastRecordDosage: nil)
    }
    
    func snapshot(for configuration: RecordingConfigurationIntent, in context: Context) async -> RecordingEntry {
        guard let selectedSetting = configuration.setting else {
            return RecordingEntry(date: .now,
                                  settingId: UUID(),
                                  productName: "지효성",
                                  dosage: 99,
                                  actingType: .long,
                                  lastRecordDate: nil,
                                  lastRecordDosage: nil)
        }
        
        let lastRecord = await InsulinModelActor.shared.fetchLastRecord(for: selectedSetting.id)
        
        return RecordingEntry(
            date: .now,
            settingId: selectedSetting.id,
            productName: selectedSetting.insulinProductName,
            dosage: selectedSetting.dosage,
            actingType: selectedSetting.actingType,
            lastRecordDate: lastRecord?.createdAt,
            lastRecordDosage: lastRecord?.dosage)
    }
    
    func timeline(for configuration: RecordingConfigurationIntent, in context: Context) async -> Timeline<RecordingEntry> {
        guard let selectedSetting = configuration.setting else {
            return Timeline(entries: [], policy: .atEnd)
        }
        
        let lastRecord = await InsulinModelActor.shared.fetchLastRecord(for: selectedSetting.id)
        let entry = RecordingEntry(
            date: .now,
            settingId: selectedSetting.id,
            productName: selectedSetting.insulinProductName,
            dosage: selectedSetting.dosage,
            actingType: selectedSetting.actingType,
            lastRecordDate: lastRecord?.createdAt,
            lastRecordDosage: lastRecord?.dosage)
        
        let nextDay = Calendar.current.startOfDay(for: .now.addingTimeInterval(86400))
        let timeLine = Timeline(entries: [entry], policy: .after(nextDay))
        
        return timeLine
    }

}



struct RecordingWidget: Widget {
    let kind: String = "RecordingWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: RecordingConfigurationIntent.self,
            provider: RecordProvider()
        ) { entry in
            RecordingWidgetView(entry: entry)
        }
        .configurationDisplayName("인슐린 투여")
        .description("인슐린 투여를 더 빠르게 기록하세요")
        .supportedFamilies([.accessoryCircular, .systemSmall])

    }
}

struct RecordingConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "인슐린 설정"
    
    @Parameter(title: "인슐린 설정")
    var setting: InsulinSettingModel?

    init(setting: InsulinSettingModel) {
        self.setting = setting
    }

    init() {}
}
