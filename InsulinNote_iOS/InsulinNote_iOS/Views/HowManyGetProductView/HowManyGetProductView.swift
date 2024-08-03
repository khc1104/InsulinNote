//
//  HowManyGetProductView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/3/24.
//

import SwiftUI

struct HowManyGetProductView: View {
    @State var months: String = "6"
    @State var unitsOfProduct: String = "300"
    var records: [InsulinRecordModel]
    
//    private var testRecords: [InsulinRecordModel]{
//        return records.filter{
//            $0.createdAt > (Calendar.current.date(byAdding: .month, value: -(Int(months) ?? 6), to: Date()) ?? .now)
//        }
//    }
    
    private var administration: Int{
        //var admin: Int = 0
        return records.filter{
            $0.createdAt > (Calendar.current.date(byAdding: .month, value: -(Int(months) ?? 6), to: .now) ?? .now)
        }.reduce(0){
            $0 + $1.administion
        }
    
    }
    private var productNumber: Int {
        administration/(Int(unitsOfProduct) ?? 300)
    }
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle(.green)
                VStack{
                    Text("개월 수")
                    TextField("개월 수를 입력", text: $months)
                        .padding()
                }
            }
            ZStack{
                Rectangle()
                    .foregroundStyle(.green)
                VStack{
                    Text("제품 단위 수")
                    TextField("단위 수를 입력", text: $unitsOfProduct)
                }
            }
            ZStack{
                Rectangle()
                    .foregroundStyle(.mint)
                Text("총 투여량: \(administration)")
            }
            ZStack{
                Rectangle()
                    .foregroundStyle(.mint)
                Text("\(unitsOfProduct)단위 펜(바이알) 개수: \(productNumber)")
            }
        }
        
//        Text("\((Calendar.current.date(byAdding: .month, value: (Int(months) ?? 6), to: Date()) ?? .now))")
//        List(testRecords){record in
//            Text("\(record.administion)")
//            Text("\(record.createdAt)")
//        }
    }
}

#Preview {
    var tempRecords: [InsulinRecordModel] = []
    var dateCompo = DateComponents()
    dateCompo.weekOfYear = -1

    for i in 0..<720{
        dateCompo.weekOfYear = -i
//        let record = InsulinRecordModel(
//            administion: i,
//            createdAt: Calendar.current.date(byAdding: .day, value: -i*10, to: Date())!,
//            updatedAt: .now)
        let record = InsulinRecordModel(
            administion: 17,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            updatedAt: .now)
        tempRecords.append(record)
    }
    
    return HowManyGetProductView(records: tempRecords)
}
