//
//  InsulinSettingColumnView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/23/24.
//

import SwiftUI

struct InsulinSettingColumnView: View {
    var insulinProductName: String = "트레시바"
    var administration: String = "22"
    
    var body: some View {
        List{
            HStack(){
                VStack(alignment: .leading){
                    Text("제품명 : \(insulinProductName)")
                    Text("단위 : \(administration)")
                }
                
                Spacer()
                
                VStack{
                    Button{
                        
                    }label: {
                        Text("편집")
                    }
                    Button{
                        
                    }label: {
                        Text("삭제")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .background(.red)
                            .foregroundStyle(.white)
                            .background(in: .rect(cornerRadius: 8))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
    }
}

#Preview {
    InsulinSettingColumnView()
}
