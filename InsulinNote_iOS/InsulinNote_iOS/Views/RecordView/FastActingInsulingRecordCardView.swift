//
//  FastActingInsulingRecordCardView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI

struct FastActingInsulingRecordCardView: View {
    var body: some View {
        VStack(alignment: .leading){ //카드
            VStack(alignment: .leading){
                Text("투여")
                    .font(.title2)
                Text("17")
                    .font(.title3)
                VStack(alignment: .leading){
                    Text("2024년 9월 4일")
                    Text("오후 1시 11분")
                }
                .font(.footnote)
                .foregroundStyle(.gray)
            }
            .padding()
        }
        .border(Color.black, width: 1)
        .padding()
    }
}
