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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("속효성")
                .font(.largeTitle)
            Text("\(lastInjectTime)")
            Text("\(defaultDosage)단위")
            Toggle(
                isOn: false,
                intent: recordingIntent
            ) {  //CustomToggleStyle 만들 수 있음
                Image(systemName: "syringe")
            }

        }
    }
}
