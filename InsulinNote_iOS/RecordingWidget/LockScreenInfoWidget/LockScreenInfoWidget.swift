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
    typealias Entry = LastDoseEntry
    
    func placeholder(in context: Context) -> LastDoseEntry {
        return LastDoseEntry(
            date: .now,
            longActingName: "지효성",
            FastActingName: "속효성",
            longActingLastDoseInToday: .now
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void){
        Task {
            let settings = await InsulinModelActor.shared.fetchAllSettings()

            guard
                let longActingSetting = settings.first(where: {
                    $0.actingType == .long
                })
            else {
                fatalError("longActingSetting is not exist")
            }
            guard
                let fastActingSetting = settings.first(where: {
                    $0.actingType == .fast
                })
            else {
                fatalError("longActingSetting is not exist")
            }
            let lastLongRecordInToday = await InsulinModelActor.shared
                .fetchLastRecord(for: longActingSetting.id)
            let lastFastRecordInToday = await InsulinModelActor.shared
                .fetchLastRecord(for: fastActingSetting.id)
            let entry = LastDoseEntry(
                date: .now,
                longActingName: longActingSetting.insulinProductName,
                FastActingName: fastActingSetting.insulinProductName,
                longActingLastDoseInToday: lastLongRecordInToday?.createdAt,
                fastActingLastDoseInToday: lastFastRecordInToday?.createdAt
            )
            
            completion(entry)
        }
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        Task {
            let settings = await InsulinModelActor.shared.fetchAllSettings()

            guard
                let longActingSetting = settings.first(where: {
                    $0.actingType == .long
                })
            else {
                fatalError("longActingSetting is not exist")
            }
            guard
                let fastActingSetting = settings.first(where: {
                    $0.actingType == .fast
                })
            else {
                fatalError("longActingSetting is not exist")
            }
            let lastLongRecordInToday = await InsulinModelActor.shared
                .fetchLastRecord(for: longActingSetting.id)
            let lastFastRecordInToday = await InsulinModelActor.shared
                .fetchLastRecord(for: fastActingSetting.id)
            
            let entry = LastDoseEntry(
                date: .now,
                longActingName: longActingSetting.insulinProductName,
                FastActingName: fastActingSetting.insulinProductName,
                longActingLastDoseInToday: lastLongRecordInToday?.createdAt,
                fastActingLastDoseInToday: lastFastRecordInToday?.createdAt
            )
            let nextDay = Calendar.current.startOfDay(for: .now.addingTimeInterval(86400))
            let timeline = Timeline(entries: [entry], policy: .after(nextDay))
            completion(timeline)
        }
    }

}

struct LastDoseEntry: TimelineEntry {
    var date: Date
    var longActingName: String
    var FastActingName: String
    var longActingLastDoseInToday: Date?
    var fastActingLastDoseInToday: Date?
}

struct LockScreenInfoWidget: Widget {
    let kind: String = "LockScreenInfoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider:
                LockScreenInfoTimeLineProvider()
        ) { entry in
            LockScreenInfoView(entry: entry)
                .modelContainer(InsulinModelActor.shared.modelContainer)
        }
        .configurationDisplayName("인슐린 투여")
        .description("인슐린 투여를 더 빠르게 기록하세요")
        .supportedFamilies([.accessoryRectangular])
    }
}
