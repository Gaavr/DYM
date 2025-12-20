//
//  Untitled.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//
import Foundation
import SwiftUI

struct Category: Identifiable {
    let id: UUID = UUID()
    var name: String
    var description: String
    var color: Color
    var icon: String
    
    let createdAt: Date
}
