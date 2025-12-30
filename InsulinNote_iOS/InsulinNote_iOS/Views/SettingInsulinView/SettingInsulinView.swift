//
//  SwiftUIView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/29/25.
//

import SwiftUI
import SwiftData

struct SettingInsulinView: View {
    @Environment(ErrorManager.self) private var errorManager
    @Environment(\.modelContext) private var insulinContext
    @Query private var insulinSettings: [InsulinSettingModel]
    
    private var longActingInsulin: InsulinSettingModel? {
        insulinSettings.first(where: { $0.actingType == .long})
    }
    private var fastActingInsulin: InsulinSettingModel? {
        insulinSettings.first(where: { $0.actingType == .fast})
    }
    
    var body: some View {
        VStack(alignment: .leading){
            EditInsulinSettingView(insulinSetting: longActingInsulin)
            EditInsulinSettingView(insulinSetting: fastActingInsulin)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    SettingInsulinView()
}
