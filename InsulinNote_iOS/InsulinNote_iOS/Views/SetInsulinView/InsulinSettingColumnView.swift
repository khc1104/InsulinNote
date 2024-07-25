//
//  InsulinSettingColumnView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/23/24.
//

import SwiftUI

struct InsulinSettingColumnView: View {
    var setting: InsulinSettingModel
    
    @Binding var selectedInsulin : InsulinSettingModel?

    var removeButtonTapped: () -> ()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("제품명 : \(setting.insulinProductName)")
                Text("단위 : \(setting.administration)")
            }
            
            Spacer()
            
            VStack{
                Button{
                    //editButtonTapped(setting)
                    selectedInsulin = setting
                }label: {
                    ZStack{
                        Rectangle()
                            .padding(.vertical, 1)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: 100)
                        Text("편집")
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button{
                    removeButtonTapped()
                }label: {
                    ZStack{
                        Rectangle()
                            .padding(.vertical, 1)
                            .foregroundColor(.red)
                            .frame(maxWidth: 100)
                        Text("삭제")
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .frame(maxWidth: .infinity)
        }
            
    }
    
}
/*
#Preview {
    InsulinSettingColumnView()
}
*/
