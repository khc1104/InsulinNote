//
//  ContentView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @AppStorage("firstLaunched") var isLaunched: Bool = false
    
    var body: some View {
        TabView{
            RecordView()
                .tabItem {
                    Label(
                        title: { Text("main") },
                        icon: { Image(systemName: "house.fill") }
                    )
                }.padding(.bottom, 10)
            RecordCalendarView()
                .tabItem {
                    Label(
                        title: { Text("calendar") },
                          icon: { Image(systemName: "calendar") }
                    )
                }.padding(.bottom, 10)
            SettingInsulinView()
                .tabItem {
                    Label(
                        title: { Text("setting") },
                          icon: { Image(systemName: "gear") }
                    )
                }.padding(.bottom, 10)
        }.onAppear{
            if !isLaunched{
                let insulin1 = InsulinSettingModel(insulinProductName: "트레시바", actingType: .long, dosage: 22, records: [], updatedAt: .now)
                modelContext.insert(insulin1)
                
                let insulin2 = InsulinSettingModel(insulinProductName: "노보래피드", actingType: .fast, dosage: 17, records: [
                    InsulinRecordModel(dosage: 17, createdAt: .now, updatedAt: .now)
                ], updatedAt: .now)
                modelContext.insert(insulin2)
                isLaunched.toggle()
            }
        }
    }
}
