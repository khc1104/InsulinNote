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
    var insulinSetting: InsulinSettingModel?
    private let widgetCenter = WidgetCenter.shared
    
    @State private var isPresentingEditSheet = false
    
    @State private var productName = ""
    @State private var dosage = "0"
    var body: some View {
        VStack(alignment: .leading){
            Text("\(insulinSetting?.actingType == .fast ? "속효성 인슐린" : "지효성 인슐린")")
                .font(.title)
                .foregroundStyle(insulinSetting?.actingType == .fast ? .fastActing : .longActing)
            ZStack(alignment: .center){
                VStack{
                    Spacer()
                    Text("\(insulinSetting?.insulinProductName ?? "설정되지 않은 인슐린")")
                    Text("투여량: \(insulinSetting?.dosage ?? 0)")
                    Spacer()
                    Button {
                        isPresentingEditSheet.toggle()
                    }label: {
                        Text("수정")
                            .foregroundStyle(insulinSetting?.actingType == .fast ? .fastActing : .longActing)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.primary, lineWidth: 1)
                            )
                    }
                    Spacer()
                }.font(.title2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(insulinSetting?.actingType == .fast ? .fastActing : .longActing, width: 1.0)
            .sheet(isPresented: $isPresentingEditSheet) {
                Form {
                    VStack{
                        HStack(){
                            Text("제품명")
                            Divider()
                            TextEditor(text: $productName)
                        }
                        HStack{
                            Text("투여량")
                            Divider()
                            TextEditor(text: $dosage)
                                .keyboardType(.numberPad)
                        }
                        Button{
                            guard let dosage = Int(dosage) else  {
                                print("정수가 아님")
                                return
                            }
                            insulinSetting?.insulinProductName = productName
                            insulinSetting?.dosage = dosage
                            widgetCenter.reloadAllTimelines()
                            isPresentingEditSheet.toggle()
                        }label: {
                            Text("수정")
                        }
                    }
                }.onAppear{
                    productName = insulinSetting?.insulinProductName ?? ""
                    dosage = String(insulinSetting?.dosage ?? 0)
                }
            }
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
