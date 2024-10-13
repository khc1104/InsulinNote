//
//  MainView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/20/24.
//

import SwiftUI
import SwiftData

//
//투여기록 DateFomat 수정해서 정렬 잘 되게 수정해야 함
//

struct MainView: View {
    @Environment(\.modelContext) var insulinContext
    @Query var insulinSettings: [InsulinSettingModel]
    
    @State var directInput: String = ""
    @State var date: Date = .now
    
    //UIScreen.main을 사용할 수 없어서 대체로 사용 할 수 있는 코드
    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    @State var windowWidth : CGFloat?
    
    var body: some View {
        NavigationStack{
            TabView{
                ForEach(insulinSettings){ setting in
                    VStack{
                        RecordInsulinView(insulinSetting: setting)
                            .frame(width: windowWidth)
                            .background(.blue, in: .rect)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onAppear{
                windowWidth = window?.screen.bounds.width ?? .zero
            }
        }
    }
    
    
}



#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InsulinSettingModel.self
                                        , configurations: config)
    for i in 1..<4{
        let insulin = InsulinSettingModel(insulinProductName: "TestInsulin\(i)", actingType: .fast, dosage: 55, records: [
            InsulinRecordModel(dosage: 17, createdAt: .now, updatedAt: .now)
        ], updatedAt: .now)
        container.mainContext.insert(insulin)
        
    }
    
    return MainView().modelContainer(container)
    
}
