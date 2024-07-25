//
//  UpdateInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/25/24.
//

import SwiftUI

struct UpdateInsulinView: View {
    
    @State var insulinProductName: String = ""
    @State var administration: String = ""
    
    var setting: InsulinSettingModel
    @Binding var selectedInsulin : InsulinSettingModel?
    
    //var updateInsulinButtonTapped: (InsulinSettingModel, String, String) -> ()
    
    var body: some View {
        
        HStack{
            VStack(alignment: .leading){
                TextField(text: $insulinProductName) {
                    Text("제품 명")
                }.textFieldStyle(.roundedBorder)
                    .shadow(radius: 2)
                TextField(text: $administration) {
                    Text("단위")
                }.textFieldStyle(.roundedBorder)
                    .shadow(radius: 2)
            }
            
            Spacer()
            
            VStack{
                Button{
                    guard let administration = Int(administration) else {return}
                    setting.insulinProductName = insulinProductName
                    setting.administration = Int(administration)
                    setting.updatedAt = .now
                    selectedInsulin = nil
                    //updateInsulinButtonTapped(setting, insulinProductName, administration)
                }label: {
                    Text("완료")
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear{
            insulinProductName = setting.insulinProductName
            administration = String(setting.administration)
        }
    }
}
