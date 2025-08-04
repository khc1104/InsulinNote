//
//  SwiftUIView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/29/25.
//

import SwiftUI
import SwiftData

struct SettingInsulinView: View {
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    
    var body: some View {
        VStack(alignment: .leading){
            EditInsulinSettingView(insulinSetting: insulinSettings.first(where: { $0.actingType == .long}))
            EditInsulinSettingView(insulinSetting: insulinSettings.first(where: { $0.actingType == .fast}))
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

#Preview {
    SettingInsulinView()
}
