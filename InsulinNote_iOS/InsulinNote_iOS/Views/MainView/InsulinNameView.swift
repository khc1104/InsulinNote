//
//  InsulinNameView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct InsulinNameView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.mint)
            Text("인슐린 이름")
        }
    }
}

#Preview {
    InsulinNameView()
}
