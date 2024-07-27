//
//  SetDefulatInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/20/24.
//

import SwiftUI
import SwiftData

struct SetInsulinSettingView: View {

    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    @State var selectedInsulin: InsulinSettingModel?
    
    @State private var isSheetViewing: Bool = false
    @State private var isAlertShowing: Bool = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    ForEach(insulinSettings){ setting in
                        HStack{
                            if selectedInsulin != nil && selectedInsulin == setting{
                                UpdateInsulinView(setting: setting, selectedInsulin: $selectedInsulin)
                            }else{
                                InsulinSettingColumnView(setting: setting, selectedInsulin: $selectedInsulin){
                                    removeButtonTapped()
                                }
                            }
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
                        Divider()
                    }
                }
                
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        isSheetViewing.toggle()
                    }label: {
                        Text("추가")
                    }
                }
            }
            .sheet(isPresented: $isSheetViewing){
                AddInsulinSettingView(isSheetViewing: $isSheetViewing)
            }
        }
        
    }
    
    func addButtonTapped(){
        // 추가 버튼 탭 했을 때
        isSheetViewing.toggle()
    }
    
    func editButtonTapped(setting: InsulinSettingModel){
        //편집 버튼 탭 했을 때
        selectedInsulin = setting
        print(selectedInsulin?.insulinProductName ?? "없음")
        
    }
    
    func updateInsulinButtonTapped(setting: InsulinSettingModel, insulinProductName: String, administration: String ){
        guard let administration = Int(administration) else {return}
        setting.insulinProductName = insulinProductName
        setting.administration = Int(administration)
        setting.updatedAt = .now
        selectedInsulin = nil
        print(selectedInsulin?.insulinProductName ?? "없어짐")
    }
    
    func removeButtonTapped(){
        //삭제 버튼 탭 했을 때
        isAlertShowing.toggle()
    }
    func confirmRemoveButtonTapped( setting: InsulinSettingModel){
        insulinContext.delete(setting)
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InsulinSettingModel.self
                                        , configurations: config)
    for i in 1..<20{
        let insulin = InsulinSettingModel(insulinProductName: "TestInsulin\(i)", administration: 55, updatedAt: .now)
        container.mainContext.insert(insulin)
    }
    
    
    return SetInsulinSettingView()
        .modelContainer(container)
}
