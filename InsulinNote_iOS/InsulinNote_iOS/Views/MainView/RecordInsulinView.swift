//
//  RecordInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/20/24.
//

import SwiftUI

struct RecordInsulinView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.gray)
            VStack{
                Text("인슐린 이름")
                Text("투여양")
                Text("")
            }
        }
    }
}

#Preview {
    RecordInsulinView()
}
