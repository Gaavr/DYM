//
//  AboutView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftUI

struct AboutView: View {
    
    let psychologyArticleText = """
    Your mind constantly produces thoughts.
    Thoughts appear automatically — you do not choose most of them.

    But you are not your thoughts.
    You are the one who notices them.

    This app creates a deliberate pause —
    a break in the automatic loop of reactive thinking.

    By presenting a single, focused message
    at the exact moment of struggle,
    it shifts your brain from autopilot
    into conscious awareness.
    """
    
    let wowWorksArticleText = """
    The app delivers a single, focused message
    at the moment you choose to open it.

    This intentional interruption breaks habitual thinking loops
    and shifts attention from reaction to observation.

    No tracking.
    No analytics.
    No cognitive overload.

    Just one message.
    One moment of awareness.
    """
    
    let whyAppExistArticleText = """
    Most mental struggles are not caused by lack of discipline,
    but by operating on autopilot.

    Dominate Your Mind exists to interrupt that state.

    It does not try to fix you.
    It does not tell you what to feel.

    It helps you notice what is already happening —
    and regain conscious control.
    """
    
    let designPhilosophyArticleText = """
    Simplicity is intentional.

    The brain processes less information more deeply.
    That is why this app avoids feeds, streaks, and notifications.

    Every element exists to reduce friction
    between awareness and action.

    Nothing more.
    Nothing distracting.
    """
    
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

                Text(psychologyArticleText)
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
