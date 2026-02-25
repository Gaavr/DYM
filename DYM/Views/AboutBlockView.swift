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
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color.black)
                    .frame(width: 72, height: 72)
                Image(systemName: systemImage)
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        Divider()
            .padding(30)
    }
}

#Preview {
    AboutBlockView(title: "Mental Discipline", text: AboutText.awarenessText, systemImage: "brain")
}
