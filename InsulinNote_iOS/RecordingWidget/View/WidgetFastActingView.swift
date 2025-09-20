//
//  WidgetFastActingView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/26/25.
//

import SwiftUI
import AppIntents

struct WidgetFastActingView: View {
    var lastInjectTime: String
    var defaultDosage: Int
    var recordingIntent: RecordingIntent
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family{
        case .accessoryCircular: //LockScreen
            VStack{
                Button("속효", intent: recordingIntent)
            }
        default: //home
            VStack(alignment: .leading) {
                Text("속효성")
                    .font(.largeTitle)
                Text("\(lastInjectTime)")
                Text("\(defaultDosage)단위")
                Toggle(
                    isOn: false,
                    intent: recordingIntent
                ) { 
                    Image(systemName: "syringe")
                }
            }
        }
    }
}
