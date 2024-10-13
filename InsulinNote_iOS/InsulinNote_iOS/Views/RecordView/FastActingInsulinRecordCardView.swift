//
//  FastActingInsulingRecordCardView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI

struct FastActingInsulinRecordCardView: View {
    var insulinRecord: InsulinRecordModel
    var body: some View {
        VStack(alignment: .leading){ //카드
            VStack(alignment: .leading){
                Text("투여")
                    .font(.title2)
                Text(String(insulinRecord.dosage))
                    .font(.title3)
                VStack(alignment: .leading){
                    Text(insulinRecord.dateString)
                    Text(insulinRecord.timeString)
                }
                .font(.footnote)
                .foregroundStyle(.gray)
            }
            .padding()
        }
        .border(Color.black, width: 1)
        .padding()
        .padding(.horizontal, 3)
        
    }
}
