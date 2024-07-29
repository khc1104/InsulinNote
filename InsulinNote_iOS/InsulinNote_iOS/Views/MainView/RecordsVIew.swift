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
    @Query var insulinSettings: [InsulinSettingModel]
    
    var body: some View{
        ScrollView{
            ForEach((insulinSettings.first?.records.sorted{ (i:InsulinRecordModel, j: InsulinRecordModel) -> Bool in
                return i.createdAt < i.updatedAt
            })!){record in
                Text("투여량: \(record.administion), createdAt: \(record.createdAt)")
            }
        }
    }
}
