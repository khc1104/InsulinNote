//
//  RecordInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/20/24.
//

import SwiftUI
import SwiftData

struct RecordInsulinView: View {
    @Environment(\.modelContext) var insulinContext
    //@Query var insulinSettings: [InsulinSettingModel]
    
    var insulinSetting: InsulinSettingModel
    
    @State var directInput: String = ""
    @State var date: Date = .now
    
    @State var showRecords: Bool = false
    var body: some View {
        //GeometryReader{ geometry in
        Grid{
            GridRow{ //인슐린 이름
                InsulinNameView(insulinName: insulinSetting.insulinProductName)
                    .gridCellColumns(4)
            }
            GridRow{ //기본 투여양
                DefaultInsulinAdministrationButton(
                    administration: insulinSetting.administration,
                    setting: insulinSetting, createNewInsulinRecord: createNewInsulinRecord(_:_:)
                )
                .gridCellColumns(4)
            }
            GridRow{ //-1, +1, +2, +3
                NearDefaultAdministrationButton(
                    administration: insulinSetting.administration,
                    addAdmin: -1,
                    setting: insulinSetting,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                NearDefaultAdministrationButton(
                    administration: insulinSetting.administration,
                    addAdmin: 1,
                    setting: insulinSetting,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                NearDefaultAdministrationButton(
                    administration: insulinSetting.administration,
                    addAdmin: 2,
                    setting: insulinSetting,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                NearDefaultAdministrationButton(
                    administration: insulinSetting.administration,
                    addAdmin: 3,
                    setting: insulinSetting,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
            }
            GridRow{ //직접입력
                DirectInputAdministrationView(
                    directInput: $directInput,
                    setting: insulinSetting,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                
            }
            GridRow{ //기록 보러 가기
                Button{
                    showRecords.toggle()
                }label:{
                    ZStack{
                        Rectangle().foregroundStyle(.green)
                        Text("기록들 보러 가기버튼(예정)")
                    }
                }
                .gridCellColumns(4)
                
            }
            .navigationDestination(isPresented: $showRecords) {
                RecordsView(insulinSetting: insulinSetting)
            }
//            GridRow{
//                HStack(alignment: .center){
//                    Circle()
//                    Circle()
//                    Circle()
//                }
//                .frame(height: 8)
//                .gridCellColumns(4)
//            }
            
        }
        .padding()
        
    }
    func createNewInsulinRecord(_ insulinSetting:InsulinSettingModel?, _ administration:Int){ //인슐린 설정의 기록 추가
        let record: InsulinRecordModel = InsulinRecordModel(administion: administration, createdAt: date, updatedAt: .now)
        if let insulinSetting{
            insulinSetting.records.append(record)
        }else{
            print("기록 추가 실패")
        }
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InsulinSettingModel.self
                                        , configurations: config)
    for i in 1..<4{
        let insulin = InsulinSettingModel(insulinProductName: "TestInsulin\(i)", administration: 55, records: [
            InsulinRecordModel(administion: 17, createdAt: .now, updatedAt: .now)
        ], updatedAt: .now)
        container.mainContext.insert(insulin)
        
    }
    
    return RecordInsulinView(insulinSetting: InsulinSettingModel(insulinProductName: "dd", administration: 12, records: [], updatedAt: .now))
        .modelContainer(container)
    
}
