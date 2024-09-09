//
//  LongActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI

struct LongActingInsulinView:View {
    var proxy: GeometryProxy
    var body: some View {
        Text("트레시바")
            .font(.title)
        VStack{
            Text("미 투여")
                .font(.title)
            Button{
                
            }label: {
                ZStack{
                    Rectangle()
                        .frame(width: 200, height: 50)
                        .foregroundStyle(.clear)
                        .border(Color.black, width: 1)
                    Text("투여")
                        .font(.title3)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: proxy.size.height * 0.4)
        .border(Color.black, width: 1)
    }
}

#Preview {
    GeometryReader{ proxy in
        LongActingInsulinView(proxy: proxy)
    }
}
