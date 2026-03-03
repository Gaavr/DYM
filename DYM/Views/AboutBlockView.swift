//
//  AboutBlockView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.01.2026.
//

import SwiftUI

struct AboutBlockView: View {
    
    let title: LocalizedStringKey
    let text: LocalizedStringKey
    let systemImage: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                   RoundedRectangle(cornerRadius: 12)
                       .fill(Color.black)
                       .frame(width: 44, height: 44)
                   Image(systemName: systemImage)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 24, height: 24)
                       .foregroundStyle(.white)
               }
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        Divider()
            .padding(30)
    }
}

//#Preview {
//    AboutBlockView(title: "Mental Discipline", text: AboutText.awarenessText, systemImage: "brain")
//}
