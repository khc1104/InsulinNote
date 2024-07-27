//
//  MainView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/20/24.
//

import SwiftUI

struct MainView: View {
    @State var directInput: String = ""
    @State var date: Date = Date()
    
    var body: some View {
        //GeometryReader{ geometry in
            Grid{
                GridRow{ //인슐린 이름
                    InsulinNameView()
                        .gridCellColumns(4)
                }
                GridRow{ //기본 투여양
                    DefaultInsulinAdministrationButton()
                        .gridCellColumns(4)
                }
                GridRow{ //-1, +1, +2, +3
                    NearDefaultAdministrationButton(addAdmin: -1)
                    NearDefaultAdministrationButton(addAdmin: 1)
                    NearDefaultAdministrationButton(addAdmin: 2)
                    NearDefaultAdministrationButton(addAdmin: 3)
                }
                GridRow{ //직접입력
                    DirectInputAdministrationView()
                    
                }
                GridRow{ //시간 피커 default는 now
                    DatePickerView()
                        .gridCellColumns(4)
                }
                GridRow{
                    HStack(alignment: .center){
                        Circle()
                        Circle()
                        Circle()
                    }
                    .frame(height: 8)
                    .gridCellColumns(4)
                }
                
            }
            .padding()
            //.frame(maxWidth: geometry.size.width * 0.9)
        //}
        
    }
}

#Preview {
    MainView()
}
