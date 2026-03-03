//
//  DeviceCapabilities.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 25.02.2026.
//


import UIKit

enum DeviceCapabilities {
    
    static let iphonesWithActionButton: [String: String] = [
        // iPhone 15 Series
        "iPhone 15 Pro": "iPhone16,1",
        "iPhone 15 Pro Max": "iPhone16,2",
        // iPhone 16 Series
        "iPhone 16": "iPhone17,3",
        "iPhone 16 Plus": "iPhone17,4",
        "iPhone 16 Pro": "iPhone17,1",
        "iPhone 16 Pro Max": "iPhone17,2",
        "iPhone 16e": "iPhone17,5",
        // iPhone 17 Series
        "iPhone 17": "iPhone18,3",
        "iPhone 17 Pro": "iPhone18,1",
        "iPhone 17 Pro Max": "iPhone18,2",
        "iPhone Air": "iPhone18,4",
        "iPhone 17e": "iPhone18,5" //но это не точно
    ]
    
    
    static var hasActionButton: Bool {
        let currentIdentifier = UIDevice.modelIdentifier
        return iphonesWithActionButton.values.contains(currentIdentifier)
    }
}

extension UIDevice {
    static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce(into: "") { result, element in
            guard let value = element.value as? Int8, value != 0 else { return }
            result.append(String(UnicodeScalar(UInt8(value))))
        }
    }
}
