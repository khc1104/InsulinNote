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
            setting: InsulinSettingModel(insulinProductName: "none", administration: 99, records: [], updatedAt: .now))
    }
    
    func timeline(for configuration: RecordingConfigurationIntent, in context: Context) async -> Timeline<RecordingEntry> {
        let entry = RecordingEntry(
            date: .now,
            setting: InsulinSettingModel(
                insulinProductName: configuration.productName,
                administration: configuration.administration,
                records: [],
                updatedAt: .now))
        let timeLine = Timeline(entries: [entry], policy: .never)
        return timeLine
    }
    
    //    func timeline(for configuration: RecordingConfigurationIntent, in context: Context) async -> Timeline<RecordingEntry> {
    //        let entry = SimpleEntry(
    //            date: .now,
    //            setting: configuration.insulinSetting,
    //
    //        )
    //        let timeLine = Timeline(entries: [entry], policy: .never)
    //        return timeLine
    //    }
    func snapshot(for configuration: RecordingConfigurationIntent, in context: Context) async -> RecordingEntry {
        return RecordingEntry(
            date: .now,
            setting: InsulinSettingModel(
                insulinProductName: configuration.productName,
                administration: configuration.administration,
                records: [],
                updatedAt: .now))
    }
    
}

struct  RecordingEntry: TimelineEntry {
    let date: Date
    let setting: InsulinSettingModel
    //let test: String
    //let emoji: String
}
//
//struct RecordingWidgetEntryView : View {
//    var entry: RecordProvider.Entry
//
//    @Environment(\.modelContext) var insulinContext
//    @Query var insulinSettings: [InsulinSettingModel]
//
//    var body: some View {
//        VStack {
//            Text(insulinSettings.first?.insulinProductName ?? "insulinName")
//                .font(.largeTitle)
//            HStack{
//                Text(insulinSettings.first?.records?.first?.createdAt ?? .now, style: .relative)
//                    .multilineTextAlignment(.trailing)
//                Text("전")
//
//            }
//            Button(intent: RecodingIntent()) {
//                Image(systemName: "syringe")
//            }.buttonStyle(.borderedProminent)
//
//            Toggle(isOn: false ,intent: RecodingIntent()) { //CustomToggleStyle 만들 수 있음
//                Image(systemName: "syringe")
//            }
//
//        }
//    }
//}

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
    }
}

struct RecordingConfigurationIntent: WidgetConfigurationIntent{
    static var title: LocalizedStringResource = "인슐린 세팅"
    
    @Parameter(title: "productName")
    var productName: String
    
    @Parameter(title: "administration")
    var administration: Int
}

//#Preview(as: .systemMedium) {
//    RecordingWidget()
//} timeline: @MainActor () async -> [any TimelineEntry]
//
