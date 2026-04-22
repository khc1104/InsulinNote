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
    @Environment(\.scenePhase) private var scenePhase
    @Environment(ErrorManager.self) private var errorManager
    
    @AppStorage("firstLaunched") var isLaunched: Bool = false
    @State private var firstSettingSheetPresented: Bool = false
    
    //탭 변경 및 앱이 백그라운드에서 돌아올 때 시간을 갱신하기 위해서 사용
    @State private var currentDate = Date()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecordView(date: currentDate)
                .tabItem {
                    Label(
                        title: { Text("main") },
                        icon: { Image(systemName: "house.fill") }
                    )
                }.padding(.bottom, 10)
                .sheet(isPresented: $firstSettingSheetPresented) {
                    FirstLunchView()
                }
                .tag(1)
            RecordCalendarView(currentDate: currentDate)
                .tabItem {
                    Label(
                        title: { Text("calendar") },
                          icon: { Image(systemName: "calendar") }
                    )
                }.padding(.bottom, 10)
                .tag(2)
            SettingInsulinView()
                .tabItem {
                    Label(
                        title: { Text("setting") },
                          icon: { Image(systemName: "gear") }
                    )
                }.padding(.bottom, 10)
                .tag(3)
        }.task{
            if !isLaunched{
                await createInitSetting()
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            currentDate = Date()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                currentDate = Date()
            }
        }
    }
    
    private func createInitSetting() async {
        do {
            try await InsulinModelActor.shared.createInitSetting()
            isLaunched.toggle()
            firstSettingSheetPresented.toggle()
        } catch {
            errorManager.showError(error as? ModelError ?? .unknwonedError)
        }
    }
}
