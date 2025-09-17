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

struct RecordProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> RecordingEntry {
        RecordingEntry(
            date: .now,
            setting: RecordingEntity(
                id: UUID(),
                insulinProductName: "Some Insulin",
                dosage: 0,
                actingType: .long
            )
        )
    }

    func timeline(for configuration: RecordingConfigurationIntent, in context: Context) async -> Timeline<RecordingEntry> {
        let now = Date()
        let calendar = Calendar.current

        // Resolve optional configuration.setting with a safe fallback
        let resolvedSetting = configuration.setting ?? RecordingEntity(
            id: UUID(),
            insulinProductName: "Some Insulin",
            dosage: 0,
            actingType: .long
        )

        guard let nextMidnight = calendar.nextDate(after: now,
                                                   matching: DateComponents(hour: 0, minute: 0, second: 0),
                                                   matchingPolicy: .strict) else {
            let entry = RecordingEntry(date: now, setting: resolvedSetting)
            return Timeline(entries: [entry], policy: .never)
        }

        let currentEntry = RecordingEntry(date: now, setting: resolvedSetting)
        let midnightEntry = RecordingEntry(date: nextMidnight, setting: resolvedSetting)
        return Timeline(entries: [currentEntry, midnightEntry], policy: .atEnd)
    }

    func snapshot(for configuration: RecordingConfigurationIntent, in context: Context) async -> RecordingEntry {
        let resolvedSetting = configuration.setting ?? RecordingEntity(
            id: UUID(),
            insulinProductName: "Some Insulin",
            dosage: 0,
            actingType: .long
        )
        return RecordingEntry(
            date: .now,
            setting: resolvedSetting
        )
    }
}

struct RecordingEntry: TimelineEntry {
    let date: Date
    let setting: RecordingEntity
}

struct RecordingWidget: Widget {
    let kind: String = "RecordingWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: RecordingConfigurationIntent.self,
            provider: RecordProvider()
        ) { entry in
            RecordingWidgetEntryView(entry: entry)
                .modelContainer(for: [InsulinSettingModel.self])
        }
        .configurationDisplayName("인슐린 투여")
        .description("인슐린 투여를 더 빠르게 기록하세요")
        .supportedFamilies([.accessoryCircular, .systemSmall])
    }
}

struct RecordingConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "인슐린 세팅"
    static var description = IntentDescription("Selects the character to display information for.")

    @Parameter(title: "productName")
    var setting: RecordingEntity?

    init(setting: RecordingEntity?) {
        self.setting = setting
    }

    init() { }
}
