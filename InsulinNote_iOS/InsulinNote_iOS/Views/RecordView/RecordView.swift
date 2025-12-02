//
//  RecordView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/9/24.
//

import SwiftData
import SwiftUI

struct RecordView: View {
    var date: Date = Date()
    @State private var isInjected: Bool = false

    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]

    @State private var selectedSetting: InsulinSettingModel?
    @State private var editedDosage: Int = 0
    @State private var recordClosure: (() -> Void) = { print("기록 에러") }

    var longActingInsulin: InsulinSettingModel? {
        insulinSettings.filter {
            $0.actingType == .long
        }.first
    }

    var fastActingInsulin: InsulinSettingModel? {
        insulinSettings.filter {
            $0.actingType == .fast
        }.first
    }

    var selectedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy년 M월 d일 E"
        return formatter.string(from: date)
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                Text("\(selectedDate)")
                    .font(.largeTitle)
                LongActingInsulinView(
                    date: date,
                    setting:
                        longActingInsulin,
                    proxy: proxy,
                ) { selectedSetting = longActingInsulin }
                FastActingInsulinView(
                    date: date,
                    setting: fastActingInsulin,
                ) { selectedSetting = fastActingInsulin }
            }
            .padding(.horizontal, 10)
        }
        .sheet(item: $selectedSetting) { setting in
            RecordDetailSheetView(
                setting: setting,
                onButtonTaped: addRecord(dosage:)
            )
            .presentationDetents([.medium])
        }
    }
    private func addRecord(dosage: Int) {  //인슐린 설정의 기록 추가
        guard let selectedSetting else {
            fatalError("Can not found InsulinSetting")
        }
        let calendar = Calendar.current
        let date = calendar.isDateInToday(date) ? Date.now : date
        let dosage = dosage
        let settingId = selectedSetting.persistentModelID
        Task {
            do {
                try await InsulinModelActor.shared.addRecord(
                    settingId,
                    dosage: dosage,
                    date: date
                )
            } catch {
                
            }
        }
    }
}
