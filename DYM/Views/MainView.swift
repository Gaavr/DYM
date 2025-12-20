//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 21.11.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
        Spacer()
            HStack {
                Button("Инфо") {
                    print("Button tapped")
                }
                Spacer()
                Button("Настройки") {
                    print("Button tapped")
                }
            }
        }
        .padding()
        .background(Image("1_discipline_14_en"))
    }
    
    
}

#Preview {
    MainView()
}
