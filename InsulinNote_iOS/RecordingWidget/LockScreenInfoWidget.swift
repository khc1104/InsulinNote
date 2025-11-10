//
//  LockScreenInfoWidget.swift
//  InsulinNote
//
//  Created by 권희철 on 9/18/25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct LockScreenInfoTimeLineProvider: TimelineProvider {
    func placeholder(in context: Context) -> InsulinInfoTimeLineEntry {
        InsulinInfoTimeLineEntry(date: .now)
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (InsulinInfoTimeLineEntry) -> Void
    ) {
        return
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<InsulinInfoTimeLineEntry>) -> Void
    ) {
        let calendar = Calendar.current
        guard
            let nextMidnight = calendar.nextDate(
                after: .now,
                matching: DateComponents(hour: 0, minute: 0, second: 0),
                matchingPolicy: .strict
            )
        else {
            let entry = InsulinInfoTimeLineEntry(date: .now)
            completion(Timeline(entries: [entry], policy: .never))
            return
        }

        let currentEntry = InsulinInfoTimeLineEntry(date: .now)
        let midnightEntry = InsulinInfoTimeLineEntry(date: nextMidnight)

        let timeLine = Timeline(
            entries: [currentEntry, midnightEntry],
            policy: .atEnd
        )
        completion(timeLine)
        return
    }
}

struct InsulinInfoTimeLineEntry: TimelineEntry {
    var date: Date
    var lastLongActingRecord: InsulinRecordModel?
    var lastFastActingRecord: InsulinRecordModel?
}

struct LockScreenInfoWidget: Widget {
    let kind: String = "LockScreenInfoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider:
                LockScreenInfoTimeLineProvider()
        ) { entry in
            LockScreenInfoView()
                .modelContainer(InsulinModelActor.shared.modelContainer)
        }
        .configurationDisplayName("인슐린 투여")
        .description("인슐린 투여를 더 빠르게 기록하세요")
        .supportedFamilies([.accessoryRectangular])
    }
}
