//
//  SwiftUIView.swift
//  InsulinNote
//
//  Created by 권희철 on 9/24/25.
//

import SwiftUI

struct FirstLunchView: View {
    var body: some View {
        NavigationStack {
            SettingInitView()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        NavigationLink("건너뛰기") {
                            WidgetExplainView()
                        }
                    }
                }
        }	
    }
}
