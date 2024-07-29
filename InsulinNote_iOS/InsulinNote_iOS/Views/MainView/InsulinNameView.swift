//
//  InsulinNameView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct InsulinNameView: View {
    var insulinName:String = "인슐린 제품 명"
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.mint)
            Text(insulinName)
        }
    }
}

#Preview {
    InsulinNameView()
}
