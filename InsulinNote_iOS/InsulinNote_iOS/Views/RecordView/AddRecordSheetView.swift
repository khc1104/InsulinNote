//
//  AddRecordSheetView.swift
//  InsulinNote
//
//  Created by 권희철 on 6/9/26.
//

import SwiftUI
import WidgetKit

struct AddRecordSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let widgetCenter = WidgetCenter.shared

    let setting: InsulinSettingModel
    let targetDate: Date
    let onSave: (Int, Date) -> Void
    
    @State private var dosage: Int
    @State private var recordTime: Date
    @State private var isTimePickerExpanded = false

    private var isFastActing: Bool {
        setting.actingType == .fast
    }

    private var accentColor: Color {
        isFastActing ? .fastActing : .longActing
    }

    init(setting: InsulinSettingModel, targetDate: Date, onSave: @escaping (Int, Date) -> Void) {
        self.setting = setting
        self.targetDate = targetDate
        self.onSave = onSave
        self._dosage = State(initialValue: setting.dosage)
        
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
        let combinedDate = calendar.date(
            bySettingHour: currentComponents.hour ?? 12,
            minute: currentComponents.minute ?? 0,
            second: currentComponents.second ?? 0,
            of: targetDate
        ) ?? targetDate
        
        self._recordTime = State(initialValue: combinedDate)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section {
                        // Dosage Wheel Picker Row
                        VStack(alignment: .leading, spacing: 8) {
                            Text("투여량 설정")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Picker("투여량", selection: $dosage) {
                                ForEach(1...80, id: \.self) { unit in
                                    Text("\(unit) 단위").tag(unit)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section {
                        // Expandable Time Picker UI Section
                        VStack(spacing: 0) {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    isTimePickerExpanded.toggle()
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 18))
                                        .foregroundColor(isTimePickerExpanded ? accentColor : .secondary)
                                    
                                    Text("투여 시간 설정")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    // Selected Time Preview
                                    Text(DateFormatter.hourMinute.string(from: recordTime))
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .rotationEffect(.degrees(isTimePickerExpanded ? 90 : 0))
                                }
                                .padding(.vertical, 12)
                            }
                            
                            if isTimePickerExpanded {
                                DatePicker(
                                    "시간",
                                    selection: $recordTime,
                                    displayedComponents: [.hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                                .padding(.vertical, 12)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                }
                
                // Confirm Bottom Button
                Button {
                    onSave(dosage, recordTime)
                    widgetCenter.reloadAllTimelines()
                    dismiss()
                } label: {
                    Text("투여 기록하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                }
                .background(Color(uiColor: .systemGroupedBackground))
            }
            .navigationTitle(isFastActing ? "속효성 인슐린 추가" : "지효성 인슐린 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
            }
        }
    }
}
