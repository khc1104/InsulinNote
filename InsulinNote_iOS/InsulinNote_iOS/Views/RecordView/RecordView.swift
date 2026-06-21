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

    @Environment(ErrorManager.self) private var errorManager
    @Environment(\.modelContext) private var insulinContext
    @Query private var insulinSettings: [InsulinSettingModel]

    @State private var selectedSetting: InsulinSettingModel?
    @State private var editingSetting: InsulinSettingModel?
    @State private var editingRecord: InsulinRecordModel?
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
        DateFormatter.fullDateKorean.string(from: date)
    }

    var hasInjectedLongActingToday: Bool {
        guard let longActingInsulin else { return false }
        let calendar = Calendar.current
        return longActingInsulin.records.contains {
            calendar.isDate($0.createdAt, inSameDayAs: date)
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(selectedDate)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.primary)
                        .padding(.top, 16)
                    
                    VStack(spacing: 20) {
                        LongActingInsulinView(
                            date: date,
                            setting: longActingInsulin,
                            proxy: proxy,
                            onButtonTapped: { selectedSetting = longActingInsulin },
                            onEditTapped: { editingSetting = longActingInsulin },
                            onRecordTapped: { record in editingRecord = record }
                        )
                        .frame(maxHeight: .infinity)
                        
                        FastActingInsulinView(
                            date: date,
                            setting: fastActingInsulin,
                            hasInjectedLongActingToday: hasInjectedLongActingToday,
                            onButtonTapped: { selectedSetting = fastActingInsulin },
                            onEditTapped: { editingSetting = fastActingInsulin },
                            onRecordTapped: { record in editingRecord = record }
                        )
                        .frame(maxHeight: .infinity)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(item: $selectedSetting) { setting in
            AddRecordSheetView(setting: setting, targetDate: date) { dosage, date in
                addRecord(dosage: dosage, date: date)
            }
            .presentationDetents([.fraction(0.75)])
        }
        .sheet(item: $editingSetting) { setting in
            EditInsulinSettingView(insulinSetting: setting)
                .presentationDetents([.medium])
        }
        .sheet(item: $editingRecord) { record in
            EditRecordSheetView(insulinRecord: record)
                .presentationDetents([.height(640)])
        }
    }
    
    private func addRecord(dosage: Int, date: Date) {  //인슐린 설정의 기록 추가
        guard let selectedSetting else {
            fatalError("Can not found InsulinSetting")
        }
        let settingId = selectedSetting.persistentModelID
        Task {
            do {
                try await InsulinModelActor.shared.addRecord(
                    settingId,
                    dosage: dosage,
                    date: date
                )
            } catch {
                errorManager.showError(error as? ModelError ?? .unknwonedError)
            }
        }
    }
}

