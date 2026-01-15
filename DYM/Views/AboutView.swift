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
            HStack {
                Image(systemName: "brain")
                    .font(.largeTitle.bold().bold().pointSize(50))
                   
                Text("Dominate your mind")
                    .font(.largeTitle.bold())
            }
            HStack() {
                Spacer()
                    .padding(1)

                Text(AboutText.psychologyArticleText)
                    .multilineTextAlignment(.leading)
            }
        }
        .navigationTitle(Text("Dominate your mind"))
        
//        Grid(alignment: .leading) {
//            GridRow {
//                Image(systemName: "brain")
//                    .font(.system(size: 50, weight: .bold))
//                Text("Dominate your mind")
//                    .font(.largeTitle.bold())
//            }
//            
//            
//
//            GridRow {
//                Color.clear
//                Text(psychologyArticleText)
//            }
//            
//            GridRow {
//                Image(systemName: "brain")
//                    .font(.system(size: 50, weight: .bold))
//                Text("Dominate your mind")
//                    .font(.largeTitle.bold())
//            }
//
//            GridRow {
//                Color.clear
//                Text(psychologyArticleText)
//            }
//            
//        }
//        .navigationTitle(Text("Dominate your mind"))
    }
}

#Preview {
    AboutView()
}
