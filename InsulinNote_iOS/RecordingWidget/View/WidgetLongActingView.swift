//
//  WidgetFastActingView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/26/25.
//

import SwiftUI

struct WidgetLongActingView: View {
    var injectTime: String
    var defaultDosage: Int
    var isInjected: Bool
    var recordingIntent: RecordingIntent
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .accessoryCircular: //LockScreen
            VStack{
                if isInjected{
                   Text("맞음")
                }else{
                    Button("지효", intent: recordingIntent)
                }
            }
        default:
            VStack(alignment: .leading) {
                Text("지효성")
                    .font(.largeTitle)
                Text("\(defaultDosage)단위")
                if !isInjected{
                    Toggle(isOn: false ,intent: recordingIntent) {
                        Image(systemName: "syringe")
                    }
                }else{
                    Text("\(injectTime) 투여됨")
                        
                }
                
            }
        }
        
    }
}
