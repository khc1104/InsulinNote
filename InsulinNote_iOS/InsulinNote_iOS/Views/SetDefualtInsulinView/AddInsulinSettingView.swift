//
//  AddInsulinSettingView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/21/24.
//

import SwiftUI
import SwiftData

enum SheetType{
    case add
    case edit
}

struct AddInsulinSettingView: View {
    let sheetType: SheetType
    
    var insulin: DefaultInsulinModel?
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
                    addInsulin()
                } label:{
                    Text("추가")
                }
            }
            .navigationTitle(sheetType == .add ? "추가" : "수정")
            //.navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            if let insulin{
                insulinProductName = insulin.insulinProductName
                adminString = String(insulin.administration)
            }
        }
    }
    
    private func addInsulin(){
        //데이터 생성
        if !insulinProductName.isEmpty && !adminString.isEmpty{
            let newInsulin = DefaultInsulinModel(insulinProductName: insulinProductName,
                                                 administration: administration,
                                                 updatedAt: .now)
            insulinContext.insert(newInsulin)
            isSheetViewing.toggle()
        }

        
    }
    private func editInsulin(){
        //데이터 수정
        if let insulin{
            insulin.insulinProductName = insulinProductName
            insulin.administration = administration
            insulin.updatedAt = .now
        }
    }
    
    
    /*
    private func save(){
        if let insulin{
            insulin.insulinProductName = insulinProductName
            insulin.administration = administration
            insulin.updatedAt = .now
        }else{
            let newInsulin = DefaultInsulinModel(insulinProductName: insulinProductName,
                                                 administration: administration,
                                                 updatedAt: .now)
            insulinContext.insert(newInsulin)
        }
    }
     */
}
