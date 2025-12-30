//
//  SettingInitView.swift
//  InsulinNote
//
//  Created by 권희철 on 9/24/25.
//

import SwiftData
import SwiftUI

struct SettingInitView: View {
    enum keyBoardFocus {
        case longActingName
        case longActingDosage
        case fastActingName
        case fastActingDosage
    }

    @Binding var settingCompleted: Bool

    @Environment(ErrorManager.self) private var errorManager
    @Environment(\.modelContext) private var modelContext

    @Query var insulinSettings: [InsulinSettingModel]

    @State private var longActingInsulinName: String = "지효성"
    @State private var longActingInsulinDosage: String = "20"
    @State private var fastActingInsulinName: String = "속효성"
    @State private var fastActingInsulinDosage: String = "15"

    @FocusState private var keyFocus: keyBoardFocus?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                VStack {
                    Text("사용하시는 인슐린과 평소 투여량을 설정해 주세요.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Spacer()

                Grid(alignment: .leading) {
                    Text("지효성 인슐린")
                        .font(.title2)
                    GridRow {
                        Text("이름")
                        TextField("지효성 인슐린 이름", text: $longActingInsulinName)
                            .foregroundStyle(.blue)
                            .focused($keyFocus, equals: .longActingName)
                            .onSubmit {
                                keyFocus = .longActingDosage
                            }
                    }
                    GridRow {
                        Text("투여량")
                        TextField(
                            "지효성 인슐린 투여량",
                            text: $longActingInsulinDosage
                        )
                        .foregroundStyle(.blue)
                        .keyboardType(.numberPad)
                        .focused($keyFocus, equals: .longActingDosage)
                        .onChange(of: longActingInsulinDosage) {
                            oldValue,
                            newValue in
                            let filtered = newValue.filter {
                                ("0"..."9").contains($0)
                            }
                            if filtered != newValue {
                                longActingInsulinDosage = filtered
                            }
                        }
                    }
                }
                .padding(20)
                .border(.longActing)

                Grid(alignment: .leading) {
                    Text("속효성 인슐린")
                        .font(.title2)
                    GridRow {
                        Text("이름")
                        TextField("속효성 인슐린 이름", text: $fastActingInsulinName)
                            .foregroundStyle(.blue)
                            .focused($keyFocus, equals: .fastActingName)
                            .onSubmit {
                                keyFocus = .fastActingDosage
                            }
                    }
                    GridRow {
                        Text("투여량")
                        TextField(
                            "속효성 인슐린 투여량",
                            text: $fastActingInsulinDosage
                        )
                        .foregroundStyle(.blue)
                        .keyboardType(.numberPad)
                        .focused($keyFocus, equals: .fastActingDosage)
                        .onChange(of: fastActingInsulinDosage) {
                            oldValue,
                            newValue in
                            let filtered = newValue.filter {
                                ("0"..."9").contains($0)
                            }
                            if filtered != newValue {
                                fastActingInsulinDosage = filtered
                            }
                        }
                    }
                }
                .padding(20)
                .border(.fastActing)
                Spacer()
                Button {
                    Task {
                        try await updateSetting()
                    }

                } label: {
                    Text("완 료")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(.primary)
                        .background(in: .capsule, fillStyle: FillStyle())
                }

            }
            .padding(20)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .font(.title3)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("\(keyFocus == .fastActingDosage ? "완료" : "다음")") {
                        switch keyFocus {
                        case .longActingName:
                            keyFocus = .longActingDosage
                        case .longActingDosage:
                            keyFocus = .fastActingName
                        case .fastActingName:
                            keyFocus = .fastActingDosage
                        case .fastActingDosage:
                            keyFocus = .none
                        case .none:
                            return
                        }
                    }
                }
            }
        }
    }
    private func updateSetting() async throws {
        do {
            guard
                let longActingInsulinSetting =
                    insulinSettings.first(where: { $0.actingType == .long })
            else { throw ModelError.updateDataError }

            guard
                let fastActingInsulinSetting =
                    insulinSettings.first(where: { $0.actingType == .fast })
            else { throw ModelError.updateDataError }
            
            try await InsulinModelActor.shared.updateSetting(
                longActingInsulinSetting.persistentModelID,
                insulinProductName: longActingInsulinName,
                dosage: strToInt(longActingInsulinDosage)
            )
            try await InsulinModelActor.shared.updateSetting(
                fastActingInsulinSetting.persistentModelID,
                insulinProductName: fastActingInsulinName,
                dosage: strToInt(fastActingInsulinDosage)
            )
            settingCompleted.toggle()
        } catch {
            errorManager.showError(error as? ModelError ?? .unknwonedError)
        }
    }

    private func strToInt(_ str: String) -> Int {
        guard let integer = Int(str) else {
            return Int(str.filter { ("0"..."9").contains($0) })!
        }
        return integer
    }
}

struct SettingInsulin {
    var name: String
    var dosageString: String

    var dosage: Int { Int(dosageString) ?? 0 }
}
