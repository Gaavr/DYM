//
//  AboutView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        VStack {
            ScrollView {
                    HStack {
                        Image("applogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .cornerRadius(16)
                            .padding(20)
                        Text(AboutText.appTitle)
                            .font(.largeTitle)
                    }
                    .padding(50)
                
                VStack(alignment: .leading) {
                    AboutBlockView(title:  AboutText.awarenessTitle,
                                   text: AboutText.awarenessText,
                                   systemImage: AboutText.awarenessSymbol)
                    AboutBlockView(title: AboutText.interruptionTitle,
                                   text: AboutText.interruptionText,
                                   systemImage: AboutText.interruptionSymbol)
                    AboutBlockView(title: AboutText.philosophyTitle,
                                   text: AboutText.philosophyText,
                                   systemImage: AboutText.philosophySymbol)
                    AboutBlockView(title: AboutText.howItWorksTitle,
                                   text: AboutText.howItWorksText,
                                   systemImage: AboutText.howItWorksSymbol)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {
                    Image(systemName: "brain")
                        .font(.system(size: 17, weight: .semibold))
                    Text(AboutText.appTitle)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        
    }
}

#Preview {
    AboutView()
}
