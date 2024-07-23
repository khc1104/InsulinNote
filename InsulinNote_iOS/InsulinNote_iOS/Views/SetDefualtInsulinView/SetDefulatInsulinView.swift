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
    private func remove(){
        //데이터 삭제
    }
}

#Preview {
    SetDefulatInsulinView()
}
