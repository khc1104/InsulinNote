//
//  LongActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI
import SwiftData

struct LongActingInsulinView:View {

    var date: Date
    var longActingInsulinSetting: InsulinSettingModel?
    var proxy: GeometryProxy
    
    @State var isInjected: Bool = false
    @State var injectedRecordToday: InsulinRecordModel? = nil
    
    @Binding var isPresented: Bool
    @Binding var dosage: Int
    @Binding var recordClosure: ()->()
    
    var body: some View {
        VStack(alignment: .leading){
            if let longActingInsulinSetting{
                Text(longActingInsulinSetting.insulinProductName)
                    .font(.title)
                    .foregroundStyle(Color.longActing)
                VStack{
                    if isInjected{
                        LongActingInsulinIsInjectedView(insulinRecord:injectedRecordToday ,proxy: proxy)
                    }else{
                        LongActingInsulinIsNotInjectedView(proxy: proxy, action: actingButtonAction)
                    }
                }.border(Color.longActing, width: 1)
            }
        }
        .onAppear{
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
    func actingButtonAction() -> () {
        if let longActingInsulinSetting{
            dosage = longActingInsulinSetting.dosage
        }else{
            dosage = 0
        }
        recordClosure = {createNewInsulinRecord()}
        isPresented.toggle()
    }
    
    func createNewInsulinRecord() -> (){ //인슐린 설정의 기록 추가
        let calendar = Calendar.current
        if let longActingInsulinSetting{
            if calendar.isDateInToday(date){
                let record: InsulinRecordModel = InsulinRecordModel(dosage: dosage, createdAt: .now, updatedAt: .now)
                longActingInsulinSetting.records.append(record)
                injectedRecordToday = record
            } else {
                let record: InsulinRecordModel = InsulinRecordModel(dosage: dosage, createdAt: date, updatedAt: .now)
                longActingInsulinSetting.records.append(record)
                injectedRecordToday = record
            }
            isInjected.toggle()
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
