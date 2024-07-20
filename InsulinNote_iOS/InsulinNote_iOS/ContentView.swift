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
    //@Query private var items: [Item]
    
    var body: some View {
        TabView{
            MainView()
                .tabItem {
                    Label(
                        title: { Text("Main") },
                        icon: { Image(systemName: "house.fill") }
                    )
                }
        }
    }
}

#Preview {
    ContentView()
}
