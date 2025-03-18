//
//  SwiftDataTestView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 2/20/25.
//

import SwiftUI
import SwiftData

struct SwiftDataTestView: View {
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    var records: [InsulinRecordModel] {
        return insulinSettings.filter{ $0.actingType == .long}.first?.records ?? []
    }
    
    var body: some View {
        List{
            ForEach(records){record in
                VStack{
                    Text("\(record.createdAt)")
                    Text("\(record.dosage)")
                }
            }
        }
    }
}

#Preview {
    SwiftDataTestView()
}
