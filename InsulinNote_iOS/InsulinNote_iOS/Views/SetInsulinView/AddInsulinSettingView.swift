//
//  AddInsulinSettingView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/21/24.
//

import SwiftUI
import SwiftData

struct AddInsulinSettingView: View {
    @State var insulinProductName: String = ""
    @State var adminString: String = ""
    private var administration: Int { Int(adminString) ?? 1}
    
    @Binding var isSheetViewing: Bool
    
    @Environment(\.modelContext) var insulinContext
    
    
    
    var body: some View {
        NavigationStack{
            Form{
                TextField(text: $insulinProductName) {
                    Text("인슐린종류")
                }
                VStack{
                    TextField(text: $adminString){
                        Text("단위")
                    }
                }
                Button{
                    createInsulinSetting()
                } label:{
                    Text("추가")
                }
            }
            .navigationTitle("추가")
        }
    }
    private func createInsulinSetting(){
        //데이터 생성
        if !insulinProductName.isEmpty && !adminString.isEmpty{
            let newInsulin = InsulinSettingModel(insulinProductName: insulinProductName,
                                                 administration: administration, records: [],
                                                 updatedAt: .now)
            insulinContext.insert(newInsulin)
            isSheetViewing.toggle()
        }
        
        
    }
    
}
