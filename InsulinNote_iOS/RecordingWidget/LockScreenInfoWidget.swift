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
        //let date = Date()
        //let entry: InsulinInfoTimeLineEntry
        //completion(entry)
        return
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<InsulinInfoTimeLineEntry>) -> Void) {
        let entry = InsulinInfoTimeLineEntry(date: Date())
        let timeLine = Timeline(entries: [entry], policy: .never)
        completion(timeLine)
        return
    }
}

struct InsulinInfoTimeLineEntry: TimelineEntry{
    var date: Date
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
