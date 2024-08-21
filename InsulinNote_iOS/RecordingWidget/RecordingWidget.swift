//
//  RecordingWidget.swift
//  RecordingWidget
//
//  Created by 권희철 on 8/13/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct RecordingWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    var body: some View {
        //        ForEach(insulinSettings){ setting in
        //            VStack {
        //                Text(setting.insulinProductName)
        //                    .font(.largeTitle)
        //                HStack{
        //                    Text(setting.records?.first?.createdAt ?? .now, style: .relative)
        //                        .multilineTextAlignment(.trailing)
        //                    Text("전")
        //
        //                }
        //                //                    Button(intent: RecodingIntent()) {
        //                //                        Image(systemName: "syringe")
        //                //                    }.buttonStyle(.borderedProminent)
        //                Toggle(isOn: false ,intent: RecodingIntent()) { //CustomToggleStyle 만들 수 있음
        //                    Image(systemName: "syringe")
        //                }
        //
        //            }
        //        }
        VStack {
            Text(insulinSettings.first?.insulinProductName ?? "insulinName")
                .font(.largeTitle)
            HStack{
                Text(insulinSettings.first?.records?.first?.createdAt ?? .now, style: .relative)
                    .multilineTextAlignment(.trailing)
                Text("전")
                
            }
            Button(intent: RecodingIntent()) {
                Image(systemName: "syringe")
            }.buttonStyle(.borderedProminent)
            
            Toggle(isOn: false ,intent: RecodingIntent()) { //CustomToggleStyle 만들 수 있음
                Image(systemName: "syringe")
            }
            
        }
    }
}

struct RecordingWidget: Widget {
    let kind: String = "RecordingWidget"
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecordingWidgetEntryView(entry:entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: [InsulinSettingModel.self])
        }
    }
}

#Preview(as: .systemMedium) {
    RecordingWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
