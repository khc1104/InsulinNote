//
//  DefaultInsulinAdministrationButton.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct DefaultInsulinAdministrationButton: View {
    var body: some View {
        Button{
            
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(.indigo)
                Text("인슐린 이름")
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    DefaultInsulinAdministrationButton()
}
