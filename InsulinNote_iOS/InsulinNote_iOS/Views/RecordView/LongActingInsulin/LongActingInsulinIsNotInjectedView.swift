//
//  LongActingInsulinIsNotInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI

struct LongActingInsulinIsNotInjectedView:View {
    let proxy: GeometryProxy
    let onButtonTapped: () -> Void
    
    var body: some View {
        VStack{
            Text("미 투여")
                .font(.title)
            Button{
                onButtonTapped()
            }label: {
                ZStack{
                    Rectangle()
                        .frame(width: 200, height: 50)
                        .foregroundStyle(.clear)
                        .border(Color.longActing, width: 1)
                    Text("투여")
                        .font(.title3)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

