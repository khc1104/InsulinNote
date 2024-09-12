//
//  LongActingInsulinIsInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI
import SwiftData

struct LongActingInsulinIsInjectedView:View {
    
    var insulinRecord: InsulinRecordModel?
    var proxy: GeometryProxy
    
    
    var today: String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일\na h시 mm분"
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
            Text("\(today)")
                .foregroundStyle(.gray)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: proxy.size.height * 0.4)
        .border(Color.black, width: 1)
    }
}

#Preview{
    GeometryReader{prox in
        LongActingInsulinIsInjectedView(proxy: prox)
    }
}
