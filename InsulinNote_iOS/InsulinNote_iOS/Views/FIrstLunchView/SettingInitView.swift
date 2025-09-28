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

    @Environment(\.modelContext) var modelContext
    @Query var insulinSettings: [InsulinSettingModel]

    @State private var longActingInsulin: SettingInsulin = .init(
        name: "지효성",
        dosage: "20"
    )
    @State private var fastActingInsulin: SettingInsulin = .init(
        name: "속효성",
        dosage: "15"
    )

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
                        TextField("지효성 인슐린 이름", text: $longActingInsulin.name)
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
                            text: $longActingInsulin.dosage
                        )
                        .foregroundStyle(.blue)
                        .keyboardType(.numberPad)
                        .focused($keyFocus, equals: .longActingDosage)
                        .onChange(of: longActingInsulin.dosage) {
                            oldValue,
                            newValue in
                            let filtered = newValue.filter {
                                ("0"..."9").contains($0)
                            }
                            if filtered != newValue {
                                longActingInsulin.dosage = filtered
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
                        TextField("속효성 인슐린 이름", text: $fastActingInsulin.name)
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
                            text: $fastActingInsulin.dosage
                        )
                        .foregroundStyle(.blue)
                        .keyboardType(.numberPad)
                        .focused($keyFocus, equals: .fastActingDosage)
                        .onChange(of: fastActingInsulin.dosage) {
                            oldValue,
                            newValue in
                            let filtered = newValue.filter {
                                ("0"..."9").contains($0)
                            }
                            if filtered != newValue {
                                fastActingInsulin.dosage = filtered
                            }
                        }
                    }
                }
                .padding(20)
                .border(.fastActing)
                Spacer()
                Button {
                    let longActingInsulinSetting =
                        insulinSettings.first { $0.actingType == .long }
                    let fastActingInsulinSetting =
                        insulinSettings.first { $0.actingType == .fast }
                    longActingInsulinSetting?.insulinProductName =
                        longActingInsulin.name
                    longActingInsulinSetting?.dosage = Int(
                        longActingInsulin.dosage
                    )!
                    fastActingInsulinSetting?.insulinProductName =
                        fastActingInsulin.name
                    fastActingInsulinSetting?.dosage = Int(
                        fastActingInsulin.dosage
                    )!
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

}

struct SettingInsulin {
    var name: String
    var dosage: String

}

#Preview {
    SettingInitView()
}
