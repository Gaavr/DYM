//
//  AddQuoteView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 06.02.2026.
//

import SwiftUI

struct AddQuoteView: View {
    
    @State private var quoteText: String = ""
    
    var body: some View {
        Form {
            TextEditor(text: $quoteText)
        }
    }
}

#Preview  {
    AddQuoteView()
}
