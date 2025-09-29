//
//  SwiftUIView.swift
//  InsulinNote
//
//  Created by 권희철 on 9/24/25.
//

import SwiftUI

struct FirstLunchView: View {
    @State private var settingCompleted: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            if !settingCompleted{
                SettingInitView(settingCompleted: $settingCompleted)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("건너뛰기") {
                                settingCompleted.toggle()
                            }
                        }
                    }
            }else{
                WidgetExplainView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("건너뛰기") {
                                dismiss()
                            }
                        }
                    }
            }
            
        }.interactiveDismissDisabled()
    }
}
