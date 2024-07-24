//
//  SetDefulatInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/20/24.
//

import SwiftUI
import SwiftData

struct SetDefulatInsulinView: View {
    var insulin: DefaultInsulinModel?
    @State private var isSheetViewing: Bool = false
    @State private var isAlertShowing: Bool = false
    
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [DefaultInsulinModel]
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    ForEach(insulinSettings){setting in
                        HStack(){
                            VStack(alignment: .leading){
                                Text("제품명 : \(setting.insulinProductName)")
                                Text("단위 : \(setting.administration)")
                            }
                            
                            Spacer()
                            
                            VStack{
                                Button{
                                    
                                }label: {
                                    Text("편집")
                                }
                                Button{
                                    removeButtonTapped()
                                }label: {
                                    Text("삭제")
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 8)
                                        .background(.red)
                                        .foregroundStyle(.white)
                                        .background(in: .rect(cornerRadius: 8))
                                }
                                .alert(
                                    Text("이 설정을 삭제 하시겠습니까?"),
                                    isPresented: $isAlertShowing
                                ){
                                    Button("예"){
                                        confirmRemoveButtonTapped(setting: setting)
                                    }
                                    Button("아니오"){
                                        
                                    }
                                } message: {
                                    Text("")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        isSheetViewing.toggle()
                    }label: {
                        Text("추가")
                    }
                }
            }
            .sheet(isPresented: $isSheetViewing, content: {
                AddInsulinSettingView(sheetType: .add, isSheetViewing: $isSheetViewing)
            })
        }
    }
    private func removeButtonTapped(){
        //삭제 버튼 탭했을때
        isAlertShowing.toggle()
    }
    private func confirmRemoveButtonTapped(setting: DefaultInsulinModel){
        insulinContext.delete(setting)
    }
}

#Preview {
    SetDefulatInsulinView()
}
