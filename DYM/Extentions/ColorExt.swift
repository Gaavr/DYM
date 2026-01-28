//
//  ColorExt.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 28.01.2026.
//

import Foundation

import SwiftUI
import UIKit

extension Color {
    func toString() -> String {
        let ui = UIColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        ui.getRed(&r, green: &g, blue: &b, alpha: &a)

        return "\(r),\(g),\(b),\(a)"
    }
}
