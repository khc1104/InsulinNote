//
//  EditInsulinSettingView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/30/25.
//

import SwiftUI

struct EditInsulinSettingView: View {
    var insulinSetting: InsulinSettingModel?
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(insulinSetting?.actingType == .fast ? "속효성 인슐린" : "지효성 인슐린")")
                .font(.title)
            ZStack(alignment: .center){
                VStack{
                    Spacer()
                    Text("\(insulinSetting?.insulinProductName ?? "설정되지 않은 인슐린")")
                    Text("투여량: \(insulinSetting?.dosage ?? 0)")
                    Spacer()
                    Button {
                        
                    }label: {
                        Text("수정")
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 1)
                            )
                    }
                    Spacer()
                }.font(.title2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(.black, width: 1.0)
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
