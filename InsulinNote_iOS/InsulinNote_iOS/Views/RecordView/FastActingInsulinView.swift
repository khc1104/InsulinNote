//
//  fastActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/9/24.
//

import SwiftUI

struct FastActingInsulinView:View {
    var body: some View {
        VStack(alignment: .leading){
            Text("노보래피드")
                .font(.title)
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<10){ _ in
                        FastActingInsulingRecordCardView()
                    }
                }
            }
            .border(Color.black, width: 1)
        }
    }
}

#Preview{
    FastActingInsulinView()
}
