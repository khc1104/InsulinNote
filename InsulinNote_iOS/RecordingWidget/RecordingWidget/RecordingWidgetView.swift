//
//  RecodingWidgetView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/25/24.
//

import AppIntents
import SwiftData
import SwiftUI

struct RecordingWidgetView: View {
    var entry: RecordingEntry
    @Environment(\.widgetFamily) var family

    let formatter: DateFormatter = {  //리턴할 때 사용
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var body: some View {
        VStack {
            switch family {
            case .accessoryCircular:
                switch entry.actingType {
                case .long:
                    if entry.lastRecordDate != nil{
                        Text("투여됨")
                    } else {
                        Toggle(
                            isOn: false,
                            intent: RecordingIntent(id: entry.settingId)
                        ) {
                            Text("지효")
                        }
                    }
                case .fast:
                    Toggle(
                        isOn: false,
                        intent: RecordingIntent(id: entry.settingId)
                    ) {
                        Text("속효")
                    }
                }
            default:
                switch entry.actingType {
                case .long:
                    VStack(alignment: .leading) {
                        Text("지효성")
                            .font(.largeTitle)
                        Text("\(entry.dosage)단위")
                        if let lastRecordDate = entry.lastRecordDate {
                            Text(
                                "\(formatter.string(from: lastRecordDate)) 투여됨"
                            )
                        } else {
                            Toggle(
                                isOn: false,
                                intent: RecordingIntent(id: entry.settingId)
                            ) {
                                Image(systemName: "syringe")
                            }

                        }

                    }
                case .fast:
                    VStack(alignment: .leading) {
                        Text("속효성")
                            .font(.largeTitle)
                        Text("\(entry.dosage)단위")
                        if let lastRecordDate = entry.lastRecordDate,
                            let lastRecordDosage = entry.lastRecordDosage
                        {
                            Text("\(formatter.string(from: lastRecordDate))")
                            Text("\(lastRecordDosage)단위")
                        }
                        Button(
                            intent: RecordingIntent(id: entry.settingId)
                        ) {
                            Image(systemName: "syringe")
                        }
                    }
                }

            }
        }
        .containerBackground(for: .widget) {
            entry.actingType == .fast
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
        let calendar = Calendar.current
        let timeFormmatter: DateFormatter = {  //리턴할 때 사용
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        let lastInjectedRecord = records.filter {
            calendar.isDateInToday($0.createdAt)
        }.sorted { $0.createdAt > $1.createdAt }

        if let record = lastInjectedRecord.first {
            return timeFormmatter.string(from: record.createdAt)
        } else {
            return "오늘 기록 없음"
        }
    }
}
