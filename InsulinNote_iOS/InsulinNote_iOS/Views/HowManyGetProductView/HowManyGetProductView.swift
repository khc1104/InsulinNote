//
//  HowManyGetProductView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/3/24.
//

import SwiftUI

enum TextFieldFocus{
    case month
    case units
}

struct HowManyGetProductView: View {
    @State var months: String = "6"
    @State var unitsOfProduct: String = "300"
    var records: [InsulinRecordModel]
    
    
    @FocusState var textFieldFocus: TextFieldFocus?
    private var administration: Int{
        return records.filter{
            $0.createdAt > (Calendar.current.date(byAdding: .month, value: -(Int(months) ?? 6), to: .now) ?? .now)
        }.reduce(0){
            $0 + $1.dosage
        }
    
    }
    private var productNumber: Int {
        let unitsOfProductDouble = Double(unitsOfProduct) ?? 1
        return Int(ceil(Double(administration)/unitsOfProductDouble))
    }
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle(.gray)
                VStack{
                    Text("개월 수")
                    TextField("개월 수를 입력", text: $months)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($textFieldFocus, equals: .month)
                        .padding()
                }
            }
            ZStack{
                Rectangle()
                    .foregroundStyle(.gray)
                VStack{
                    Text("제품 단위 수")
                    TextField("단위 수를 입력", text: $unitsOfProduct)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($textFieldFocus, equals: .units)
                        .padding()
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
        .onTapGesture {
            textFieldFocus = nil
        }
        

    }
}

#Preview {
    var tempRecords: [InsulinRecordModel] = []
    var dateCompo = DateComponents()
    dateCompo.weekOfYear = -1

    for i in 0..<720{
        dateCompo.weekOfYear = -i
        let record = InsulinRecordModel(
            administion: 1,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            updatedAt: .now)
        tempRecords.append(record)
    }
    
    return HowManyGetProductView(records: tempRecords)
}
