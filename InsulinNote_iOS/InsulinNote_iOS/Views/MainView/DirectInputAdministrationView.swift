//
//  DirectInputAdministrationView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct DirectInputAdministrationView: View {
    @Binding var directInput: String
    
    var setting :InsulinSettingModel?
    
    var createNewInsulinRecord: (InsulinSettingModel?, Int) -> ()
    var body: some View {
        ZStack(alignment:.center){
            Rectangle()
                .foregroundStyle(.orange)
            TextField("투여량 직접입력", text: $directInput)
                .foregroundStyle(.black)
        }
        .gridCellColumns(2)
        Button{
            if !directInput.isEmpty{
                createNewInsulinRecord(setting, Int(directInput) ?? setting?.administration ?? 0)
                directInput = ""
            }
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(.yellow)
                Text("추가")
                    .foregroundStyle(.black)
            }
        }
        .gridCellColumns(2)
    }
}
