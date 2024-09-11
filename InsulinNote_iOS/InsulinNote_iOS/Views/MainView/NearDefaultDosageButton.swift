//
//  NearDefaultAdministrationButton.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct NearDefaultDosageButton: View {
    var dosage: Int = 0
    var addAdmin: Int = 1
    
    var setting :InsulinSettingModel?
    
    var createNewInsulinRecord: (InsulinSettingModel?, Int) -> ()
    var body: some View {
        Button{
            createNewInsulinRecord(setting, (dosage + addAdmin))
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(.gray)
                Text("\(addAdmin < 0 ? "" : "+")\(addAdmin)")
                    .foregroundStyle(.black)
            }
            
        }
    }
}

