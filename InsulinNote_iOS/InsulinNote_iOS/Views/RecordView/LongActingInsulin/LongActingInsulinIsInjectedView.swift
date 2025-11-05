//
//  LongActingInsulinIsInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI
import SwiftData

struct LongActingInsulinIsInjectedView:View {
    let insulinRecord: InsulinRecordModel?
    let proxy: GeometryProxy
    
    var injectedDate: String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        if let insulinRecord{
            return formatter.string(from: insulinRecord.createdAt)
        }else{
            return "없음"
        }
    }
    
    var body: some View {
        VStack{
            Text("투여 함")
                .font(.largeTitle)
            if let insulinRecord{
                Text("\(insulinRecord.dosage)")
                    .font(.title)
            }
            Text("\(injectedDate)")
                .foregroundStyle(.gray)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
