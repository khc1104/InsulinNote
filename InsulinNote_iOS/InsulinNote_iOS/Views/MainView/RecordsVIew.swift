//
//  recordsVIew.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/29/24.
//

import SwiftUI
import SwiftData

struct RecordsView: View{
    @Environment(\.modelContext) var insulinContext
    //@Query var insulinSettings: [InsulinSettingModel]
    var insulinSetting: InsulinSettingModel
    
    var body: some View{
        List{
            ForEach(insulinSetting.records){ record in
                Text("투여량: \(record.administion), createdAt: \(record.createdAt)")
            }
        }
    }
}
