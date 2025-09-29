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
    @State private var firstSettingSheetPresented: Bool = false
    
    var body: some View {
        TabView{
            RecordView()
                .tabItem {
                    Label(
                        title: { Text("main") },
                        icon: { Image(systemName: "house.fill") }
                    )
                }.padding(.bottom, 10)
                .sheet(isPresented: $firstSettingSheetPresented) {
                    FirstLunchView()
                }
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
                let longActionInsulin = InsulinSettingModel(insulinProductName: "지효성", actingType: .long, dosage: 20, records: [], updatedAt: .now)
                modelContext.insert(longActionInsulin)
                
                let fastActingInsulin = InsulinSettingModel(insulinProductName: "속효성", actingType: .fast, dosage: 15, records: [], updatedAt: .now)
                modelContext.insert(fastActingInsulin)
                isLaunched.toggle()
                firstSettingSheetPresented.toggle()
            }
            
        }
    }
}
