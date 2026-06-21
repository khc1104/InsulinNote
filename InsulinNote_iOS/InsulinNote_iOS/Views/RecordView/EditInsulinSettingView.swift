//
//  EditInsulinSettingView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/30/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct EditInsulinSettingView: View {
    let insulinSetting: InsulinSettingModel
    private let widgetCenter = WidgetCenter.shared
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ErrorManager.self) private var errorManager
    
    @State private var productName = ""
    @State private var dosage = ""
    
    private var isFastActing: Bool {
        insulinSetting.actingType == .fast
    }
    
    private var accentColor: Color {
        isFastActing ? .fastActing : .longActing
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("인슐린 정보").font(.footnote).foregroundColor(.secondary)) {
                    HStack {
                        Text("제품명")
                            .frame(width: 80, alignment: .leading)
                        TextField("예: 트레시바, 노보래피드", text: $productName)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("기본 투여량")
                            .frame(width: 80, alignment: .leading)
                        TextField("기본 투여량 단위", text: $dosage)
                            .keyboardType(.numberPad)
                            .onChange(of: dosage) { oldValue, newValue in
                                let filtered = newValue.filter { ("0"..."9").contains($0) }
                                if filtered != newValue {
                                    dosage = filtered
                                }
                            }
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(isFastActing ? "속효성 인슐린 설정" : "지효성 인슐린 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        Task {
                            await updateSetting()
                        }
                    }
                    .bold()
                    .disabled(productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || dosage.isEmpty || dosage == "0")
                    .foregroundColor(accentColor)
                }
            }
            .onAppear {
                productName = insulinSetting.insulinProductName
                dosage = String(insulinSetting.dosage)
            }
        }
    }
    
    private func updateSetting() async {
        do {
            let dosageInt = Int(dosage) ?? insulinSetting.dosage
            
            try await InsulinModelActor.shared.updateSetting(
                insulinSetting.persistentModelID,
                insulinProductName: productName,
                dosage: dosageInt
            )
            
            widgetCenter.reloadAllTimelines()
            dismiss()
        } catch {
            errorManager.showError(error as? ModelError ?? .unknwonedError)
        }
    }
}

#Preview {
    EditInsulinSettingView(
        insulinSetting: InsulinSettingModel(
            insulinProductName: "트레시바",
            actingType: .long,
            dosage: 20,
            records: [],
            updatedAt: .now)
    )
}
