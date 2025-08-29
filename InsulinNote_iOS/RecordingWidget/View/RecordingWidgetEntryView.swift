//
//  RecodingWidgetView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/25/24.
//

import AppIntents
import SwiftData
import SwiftUI

struct RecordingWidgetEntryView: View {
    var entry: RecordProvider.Entry
    @Environment(\.widgetFamily) var family

    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]

    var formatter: DateFormatter {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "M월 dd일"
        return format
    }

    var body: some View {
        VStack {
            switch family {
            case .accessoryCircular:  //LockScreen
                ZStack {
                    if !getIsInjected(
                        records: entry.setting.insulinSetting.records
                    ) {
                        Button(
                            entry.setting.insulinSetting.actingType == .fast
                                ? "속효" : "지효",
                            intent: RecordingIntent(
                                id: entry.setting.insulinSetting.id.uuidString
                            )
                        )
                    } else {
                        Text("맞음")
                    }
                }
            default:  //Home
                switch entry.setting.insulinSetting.actingType {
                case .fast:
                    WidgetFastActingView(
                        lastInjectTime: getLastInjected(
                            records: entry.setting.insulinSetting.records
                        ),
                        defaultDosage: entry.setting.insulinSetting.dosage,
                        recordingIntent: RecordingIntent(
                            id: entry.setting.insulinSetting.id.uuidString
                        )
                    )
                case .long:
                    WidgetLongActingView(
                        injectTime: getLastInjected(
                            records: entry.setting.insulinSetting.records
                        ),
                        defaultDosage: entry.setting.insulinSetting.dosage,
                        isInjected: getIsInjected(
                            records: entry.setting.insulinSetting.records
                        ),
                        recordingIntent: RecordingIntent(
                            id: entry.setting.insulinSetting.id.uuidString
                        )
                    )
                }
            }
        }
        .containerBackground(for: .widget) {
            entry.setting.insulinSetting.actingType == .fast
                ? Color.fastActing : Color.longActing
        }

    }

    private func getIsInjected(records: [InsulinRecordModel]) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let strToday = formatter.string(from: today)

        let record = records.filter {
            return formatter.string(from: $0.createdAt) == strToday
        }.sorted(by: { $0.createdAt > $1.createdAt })

        if record.isEmpty { return false } else { return true }
    }

    private func getLastInjected(records: [InsulinRecordModel]) -> String {
        let dateFormatter: DateFormatter = {  //날짜 비교용
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        let timeFormmatter: DateFormatter = {  //리턴할 때 사용
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        let lastInjectedRecord = records.filter {
            let today = dateFormatter.string(from: .now)
            let recordDate = dateFormatter.string(from: $0.createdAt)
            return today == recordDate
        }.sorted { $0.createdAt > $1.createdAt }

        if let record = lastInjectedRecord.first {
            return timeFormmatter.string(from: record.createdAt)
        } else {
            return "오늘 기록 없음"
        }
    }
}
