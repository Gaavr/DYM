//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 21.11.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("1_discipline_08_ru")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()

                VStack {
                    Spacer()
                    HStack {
                        NavigationLink(destination: AboutView()) {
                            Label("About", systemImage: "info.circle")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Label("Settings", systemImage: "gearshape")
                                .labelStyle(.iconOnly)
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
    
    
}

#Preview {
    MainView()
}
