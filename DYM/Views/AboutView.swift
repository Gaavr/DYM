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
            Text("Dominate your mind")
                .font(.largeTitle.bold())
                Spacer()
            HStack {
                Image(systemName: "brain")
                    .font(.largeTitle.bold().bold().pointSize(50))
                Text("Dominate your mind")
                    .font(.largeTitle.bold())
                
            }
        }
    }
}

#Preview {
    AboutView()
}
