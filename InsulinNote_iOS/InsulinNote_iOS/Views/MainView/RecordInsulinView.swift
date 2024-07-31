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
    @Query var insulinSettings: [InsulinSettingModel]
    
    @State var directInput: String = ""
    @State var date: Date = .now
    
    
    var body: some View {
        //GeometryReader{ geometry in
        Grid{
            GridRow{ //인슐린 이름
                InsulinNameView(insulinName: insulinSettings.first?.insulinProductName ?? "오류")
                    .gridCellColumns(4)
            }
            GridRow{ //기본 투여양
                DefaultInsulinAdministrationButton(
                    administration: insulinSettings.first?.administration ?? 0,
                    setting: insulinSettings.first, createNewInsulinRecord: createNewInsulinRecord(_:_:)
                )
                .gridCellColumns(4)
            }
            GridRow{ //-1, +1, +2, +3
                NearDefaultAdministrationButton(
                    administration: insulinSettings.first?.administration ?? 0,
                    addAdmin: -1,
                    setting: insulinSettings.first,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                NearDefaultAdministrationButton(
                    administration: insulinSettings.first?.administration ?? 0,
                    addAdmin: 1,
                    setting: insulinSettings.first,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                NearDefaultAdministrationButton(
                    administration: insulinSettings.first?.administration ?? 0,
                    addAdmin: 2,
                    setting: insulinSettings.first,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                NearDefaultAdministrationButton(
                    administration: insulinSettings.first?.administration ?? 0,
                    addAdmin: 3,
                    setting: insulinSettings.first,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
            }
            GridRow{ //직접입력
                DirectInputAdministrationView(
                    directInput: $directInput,
                    setting: insulinSettings.first,
                    createNewInsulinRecord: createNewInsulinRecord(_:_:))
                
            }
            GridRow{ //기록 보러 가기
                ZStack{
                    Rectangle().foregroundStyle(.green)
                    Text("기록들 보러 가기버튼(예정)")
                }
                .gridCellColumns(4)
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
    
    return RecordInsulinView().modelContainer(container)
    
}
