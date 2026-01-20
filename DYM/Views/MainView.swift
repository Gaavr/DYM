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
                TabView {
                    Tab("DYM", systemImage: "brain") {
                        
                    }
                    Tab("About", systemImage: "info.circle") {
                        AboutView()
                    }
                    Tab("Settings", systemImage: "gearshape.fill") {
                        
                    }
//                  TODO: Говорят нельзя юзать роль поиск чтобы отделить кнопку добавления https://developer.apple.com/design/human-interface-guidelines/tab-bars
                    Tab("Add", systemImage: "plus", role: .search ) {
                        
                    }
                }
                .labelStyle(.iconOnly)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainView()
}
