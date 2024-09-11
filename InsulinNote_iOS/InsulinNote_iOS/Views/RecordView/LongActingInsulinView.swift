//
//  LongActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI

struct LongActingInsulinView:View {
    var insulingSetting: InsulinSettingModel?
    var proxy: GeometryProxy
    @Binding var isInjected: Bool
    
    var body: some View {
        if let insulingSetting{
            Text(insulingSetting.insulinProductName)
                .font(.title)
            if isInjected{
                LongActingInsulinIsInjectedView(proxy: proxy)
            }else{
                LongActingInsulinIsNotInjectedView(proxy: proxy, isInjected: $isInjected)
            }
        }
    }
}

//#Preview {
//    GeometryReader{ proxy in
//        LongActingInsulinView(proxy: proxy)
//    }
//}
