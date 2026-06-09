//
//  EditRecordSheetView.swift
//  InsulinNote
//
//  Created by 권희철 on 6/9/26.
//

import SwiftData
import SwiftUI
import WidgetKit

struct EditRecordSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ErrorManager.self) private var errorManager
    let widgetCenter = WidgetCenter.shared

    let insulinRecord: InsulinRecordModel

    @State private var dosageString: String = ""
    @State private var recordTime = Date()
    @State private var showDeleteAlert = false

    private var isFastActing: Bool {
        insulinRecord.setting?.actingType == .fast
    }

    private var accentColor: Color {
        isFastActing ? .fastActing : .longActing
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 수정 대상 기록 정보 요약 헤더
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(accentColor)
                            .font(.system(size: 20))

                        Text("수정 대상 기록")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.secondary)

                        Spacer()
                    }

                    HStack {
                        Text(insulinRecord.timeString)
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Text("\(insulinRecord.dosage) 단위")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(accentColor)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(accentColor.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(accentColor.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                Form {
                    Section {
                        // 투여량 키보드 입력 영역
                        VStack(alignment: .leading, spacing: 8) {
                            Text("투여량 설정")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)

                            HStack {
                                Spacer()
                                TextField("0", text: $dosageString)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 36, weight: .bold))
                                    .frame(width: 120)
                                    .onChange(of: dosageString) {
                                        oldValue,
                                        newValue in
                                        let filtered = newValue.filter {
                                            ("0"..."9").contains($0)
                                        }
                                        if filtered != newValue {
                                            dosageString = filtered
                                        }
                                    }

                                Text("단위")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }

                    Section {
                        // 휠 스타일로 바로 노출되는 시간 피커
                        VStack(alignment: .leading, spacing: 8) {
                            Text("투여 시간 설정")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)

                            DatePicker(
                                "시간",
                                selection: $recordTime,
                                displayedComponents: [.hourAndMinute]
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "ko_KR"))
                            .frame(height: 120)
                            .clipped()
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 4)

                    }
                    // 수정 완료 및 삭제 버튼 (폼의 가장 아래에 배치하여 키보드 활성화 시 키보드 밑으로 가려지며, 기본 상태에서는 아래 1/3만 살짝 노출되게 함)
                    Section {
                        VStack(spacing: 12) {
                            // 수정 완료 버튼
                            Button {
                                Task {
                                    await saveRecord()
                                }
                            } label: {
                                Text("수정 완료")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(dosageString.isEmpty || dosageString == "0" ? accentColor.opacity(0.4) : accentColor)
                                    .cornerRadius(12)
                            }
                            .disabled(dosageString.isEmpty || dosageString == "0")
                            .buttonStyle(.plain)
                            
                            // 투여 기록 삭제 버튼
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Text("투여 기록 삭제")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 16)
                    }
                }
                .scrollDismissesKeyboard(.immediately)  // 스크롤 시 키보드 즉시 닫기
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(isFastActing ? "속효성 기록 수정" : "지효성 기록 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }

                // 키보드 상단 완료 버튼
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("완료") {
                        hideKeyboard()
                    }
                    .foregroundColor(accentColor)
                }
            }
            .onAppear {
                dosageString = String(insulinRecord.dosage)
                recordTime = insulinRecord.createdAt
            }
            .alert("투여 기록 삭제", isPresented: $showDeleteAlert) {
                Button("취소", role: .cancel) {}
                Button("삭제", role: .destructive) {
                    Task {
                        await deleteRecord()
                    }
                }
            } message: {
                Text("이 투여 기록을 삭제하시겠습니까? 삭제된 기록은 복구할 수 없습니다.")
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    private func saveRecord() async {
        guard let dosage = Int(dosageString) else { return }
        do {
            try await InsulinModelActor.shared.updateRecord(
                insulinRecord.persistentModelID,
                dosage: dosage,
                date: recordTime
            )
            widgetCenter.reloadAllTimelines()
            dismiss()
        } catch {
            errorManager.showError(error as? ModelError ?? .unknwonedError)
        }
    }

    private func deleteRecord() async {
        do {
            try await InsulinModelActor.shared.deleteRecord(
                insulinRecord.persistentModelID
            )
            widgetCenter.reloadAllTimelines()
            dismiss()
        } catch {
            errorManager.showError(error as? ModelError ?? .unknwonedError)
        }
    }
}
