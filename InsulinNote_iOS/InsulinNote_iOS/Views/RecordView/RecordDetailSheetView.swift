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

    @Binding var dosage: Int
    var recordingAction: () -> Void = {}

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
                    recordingAction()
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
}
