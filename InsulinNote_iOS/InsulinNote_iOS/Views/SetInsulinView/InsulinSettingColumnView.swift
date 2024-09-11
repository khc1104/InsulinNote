//
//  InsulinSettingColumnView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/23/24.
//

import SwiftUI

struct InsulinSettingColumnView: View {
    var setting: InsulinSettingModel
    
    @Binding var selectedInsulin: InsulinSettingModel?
    
    @State private var isGetProductSheetShowing: Bool = false

    var removeButtonTapped: () -> ()
    
    var body: some View {
        Grid{
            GridRow{
                HStack{
                    VStack(alignment: .leading){
                        Text("제품명 : \(setting.insulinProductName)")
                        Text("단위 : \(setting.dosage)")
                    }
                    Spacer()
                }
                .gridCellColumns(2)
                
                Button{
                    
                }label: {
                    Button{
                        isGetProductSheetShowing.toggle()
                    }label: {
                        ZStack{
                            Rectangle()
                                .foregroundStyle(.mint)
                            Text("제품 수 환산")
                                .padding(.horizontal, 2)
                                .foregroundStyle(.black)
                        }
                    }
                    
                }
                .gridCellColumns(1)
            }
            GridRow{
                Button{
                    removeButtonTapped()
                }label: {
                    ZStack{
                        Rectangle()
                            .padding(.vertical, 1)
                            .foregroundColor(.red)
                            //.frame(maxWidth: 100)
                        Text("삭제")
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .gridCellColumns(1)
                
                Button{
                    //editButtonTapped(setting)
                    selectedInsulin = setting
                }label: {
                    ZStack{
                        Rectangle()
                            .padding(.vertical, 1)
                            .foregroundColor(Color.gray)
                            //.frame(maxWidth: 100)
                        Text("편집")
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .gridCellColumns(2)
                
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $isGetProductSheetShowing, content: {
            HowManyGetProductView(records: setting.records ?? [])
        })
            
    }
    
}
/*
#Preview {
    InsulinSettingColumnView()
}
*/
