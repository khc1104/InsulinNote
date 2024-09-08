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
    var records: [InsulinRecordModel]{
        insulinSetting.records.sorted{ $0.createdAt > $1.createdAt}
    }
    
    var body: some View{
        List{
            ForEach(records){ record in
                Text("투여량: \(record.administion)")
                Text("투여시간: \(record.createdAt)")
            }
        }
    }
}
