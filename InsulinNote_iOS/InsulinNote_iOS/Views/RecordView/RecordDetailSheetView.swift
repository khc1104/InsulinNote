//
//  RecordDetailSheetView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/12/25.
//
import SwiftUI
import WidgetKit

struct RecordDetailSheetView: View {
    @Environment(\.dismiss) var dismiss
    let widgetCenter = WidgetCenter.shared

    @State var dosage: Int
    let setting: InsulinSettingModel
    let recordingAction: (Int) -> Void
    
    init(setting: InsulinSettingModel, onButtonTaped: @escaping (Int) -> Void){
        self.setting = setting
        self.recordingAction = onButtonTaped
        self._dosage = State(initialValue: Int(setting.dosage))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("dosage", selection: $dosage) {
                    ForEach(1...80, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)

                Button("기록") {
                    recordingAction(dosage)
                    widgetCenter.reloadAllTimelines()
                    dismiss()
                }
                Spacer()
            }
            .font(.title2)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
    func addRecordAction(insulinSetting: InsulinSettingModel?, date: Date) { //인슐린 설정의 기록 추가
        guard let insulinSetting else {
            fatalError("Can not found InsulinSetting")
        }
        let calendar = Calendar.current
        let date = calendar.isDateInToday(date) ? Date.now : date
        let dosage = dosage
        let settingId = insulinSetting.persistentModelID
        Task{
            await InsulinModelActor.shared.addRecord(settingId, dosage: dosage, date: date)
        }
    }
}
