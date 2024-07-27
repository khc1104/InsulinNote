//
//  NearDefaultAdministrationButton.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct NearDefaultAdministrationButton: View {
    var addAdmin: Int = 1
    var body: some View {
        Button{
            
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(.gray)
                Text("\(addAdmin < 0 ? "" : "+")\(addAdmin)")
                    .foregroundStyle(.black)
            }
            //.aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
        }
    }
}

#Preview {
    NearDefaultAdministrationButton()
}
