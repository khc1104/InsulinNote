//
//  fastActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/9/24.
//

import SwiftUI
import SwiftData

struct FastActingInsulinView:View {
    @Environment(\.modelContext) var insulinContext
//    @Query(
//        filter: #Predicate<InsulinRecordModel>{ $0.createdAt < $0.today},
//        sort: \.createdAt
//    )
//    var insulinRecords: [InsulinRecordModel]
    var insulinSetting: InsulinSettingModel?
    
    private var todayRecords: [InsulinRecordModel]{
        if let insulinSetting{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return insulinSetting.records.filter{
                formatter.string(from: $0.createdAt) == formatter.string(from: Date())
            }.sorted(by: {$0.createdAt > $1.createdAt})
        }else{
            return []
        }
    }
    
    var body: some View {
        if let insulinSetting{
            VStack(alignment: .leading){
                Text(insulinSetting.insulinProductName)
                    .font(.title)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(todayRecords){ record in
                            FastActingInsulinRecordCardView(insulinRecord: record)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color.black, width: 1)
            }.onAppear{
                //print(insulinSetting.actingType)
                print(insulinSetting.records)
            }
            
            Button{
                createFastInsulinRecord()
            }label: {
                ZStack{
                    Rectangle()
                    //.frame(width: proxy.size.width - 20, height: 50)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .foregroundStyle(.clear)
                        .border(Color.black, width: 1)
                    Text("투여")
                        .font(.title3)
                }
            }
        }
    }
    
    func createFastInsulinRecord() -> (){ //인슐린 설정의 기록 추가
        if let insulinSetting{
            let record: InsulinRecordModel = InsulinRecordModel(dosage: insulinSetting.dosage, createdAt: .now, updatedAt: .now)
            insulinSetting.records.append(record)
            //injectedRecordToday = record
        }else{
            print("세팅이 없음")
            
        }
    }
}

#Preview{
    FastActingInsulinView()
}
