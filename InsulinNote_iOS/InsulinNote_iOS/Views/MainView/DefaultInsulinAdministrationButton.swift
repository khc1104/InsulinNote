//
//  DefaultInsulinAdministrationButton.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct DefaultInsulinAdministrationButton: View {
    var administration: Int = 0
    var setting :InsulinSettingModel?
    
    var createNewInsulinRecord: (InsulinSettingModel?, Int) -> ()
    
    var body: some View {
        Button{
            createNewInsulinRecord(setting, administration)
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(.indigo)
                Text("\(administration)")
                    .foregroundStyle(.black)
            }
        }
    }
}
