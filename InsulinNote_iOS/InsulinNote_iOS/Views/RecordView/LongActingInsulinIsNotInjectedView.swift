//
//  LongActingInsulinIsNotInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI

struct LongActingInsulinIsNotInjectedView:View {
    var proxy: GeometryProxy
    @Binding var isInjected: Bool
    var body: some View {
        VStack{
            Text("미 투여")
                .font(.title)
            Button{
                isInjected.toggle()
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

//#Preview {
//    GeometryReader{ proxy in
//        LongActingInsulinIsNotInjectedView(proxy: proxy)
//    }
//}
