//
//  DirectInputAdministrationView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct DirectInputAdministrationView: View {
    @State var directInput: String = ""
    var body: some View {
        ZStack(alignment:.center){
            Rectangle()
                .foregroundStyle(.orange)
            TextField("투여량 직접입력", text: $directInput)
                .foregroundStyle(.black)
        }
        .gridCellColumns(2)
        Button{
            
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(.yellow)
                Text("+3")
                    .foregroundStyle(.black)
            }
        }
        .gridCellColumns(2)
    }
}

#Preview {
    DirectInputAdministrationView()
}
