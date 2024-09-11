//
//  LongActingInsulinIsInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI

struct LongActingInsulinIsInjectedView:View {
    var proxy: GeometryProxy
    var date: Date = Date()
    
    var today: String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일\na h시 mm분"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack{
            Text("투여 함")
                .font(.largeTitle)
            Text("22")
                .font(.title)
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
