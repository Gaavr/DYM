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
                    Text("about.appTitle")
                        .font(.largeTitle)
                }
                .padding(10)
                
                Divider()
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    AboutBlockView(title: "about.awareness.title",
                                   text: "about.awareness.text",
                                   systemImage: "eye")
                    AboutBlockView(title: "about.interruption.title",
                                   text: "about.interruption.text",
                                   systemImage: "scope")
                    AboutBlockView(title: "about.howItWorks.title",
                                   text: "about.howItWorks.text",
                                   systemImage: "gearshape")
                    AboutBlockView(title: "about.privacy.title",
                                   text: "about.privacy.text",
                                   systemImage: "lock.shield")
                    VStack {
                        HStack {
                            Text("disclaimer.general")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                            HStack(spacing: 6) {
                                Spacer()
                                Text("version.name")
                                Text("\(version) (\(build))")
                                Spacer()
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {
                    Image(systemName: "brain")
                        .font(.system(size: 17, weight: .semibold))
                    Text("about.appTitle")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        
    }
}

#Preview {
    AboutView()
}
