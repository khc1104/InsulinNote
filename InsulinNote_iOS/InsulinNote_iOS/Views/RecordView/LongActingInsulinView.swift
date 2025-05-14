//
//  LongActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI
import SwiftData

struct LongActingInsulinView:View {

    var date: Date = Date()
    var longActingInsulinSetting: InsulinSettingModel?
    var proxy: GeometryProxy
    
    @State var isInjected: Bool = false
    @State var injectedRecordToday: InsulinRecordModel? = nil
    
    var body: some View {
        VStack(alignment: .leading){
            if let longActingInsulinSetting{
                Text(longActingInsulinSetting.insulinProductName)
                    .font(.title)
                if isInjected{
                    LongActingInsulinIsInjectedView(insulinRecord:injectedRecordToday ,proxy: proxy)
                }else{
                    LongActingInsulinIsNotInjectedView(proxy: proxy, isInjected: $isInjected){
                        createNewInsulinRecord()
                    }
                }
            }
        }.onAppear{
            if let longActingInsulinSetting{
                injectedRecordToday = getIsInjected(records: longActingInsulinSetting.records)
                if self.injectedRecordToday == nil{
                    self.isInjected = false
                }else{
                    self.isInjected = true
                    print("있음")
                }
            }
        }
    }
    
    func createNewInsulinRecord() -> (){ //인슐린 설정의 기록 추가
        if let longActingInsulinSetting{
            let record: InsulinRecordModel = InsulinRecordModel(dosage: longActingInsulinSetting.dosage, createdAt: date, updatedAt: date)
            longActingInsulinSetting.records.append(record)
            injectedRecordToday = record
        }else{
            print("세팅이 없음")
            
        }
    }
    
    private func getIsInjected(records: [InsulinRecordModel]) -> InsulinRecordModel?{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let strToday = formatter.string(from: date)
        
        return records.filter{
            return formatter.string(from: $0.createdAt) == strToday
        }.sorted(by: {$0.createdAt > $1.createdAt}).first
        
        
    }
    
}

//#Preview {
//    GeometryReader{ proxy in
//        LongActingInsulinView(proxy: proxy)
//    }
//}
