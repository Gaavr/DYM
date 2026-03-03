//
//  SupportMail.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.02.2026.
//


import Foundation

enum SupportMail {
    static let subject = "DYM — Support"
    
    static func url(body: String) -> URL? {
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = AppConstants.supportEmail
        c.queryItems = [
            .init(name: "subject", value: subject),
            .init(name: "body", value: body)
        ]
        return c.url
    }
    
    static func defaultBody() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        let iOS = ProcessInfo.processInfo.operatingSystemVersionString
        
        let greeting = NSLocalizedString("support.mail.greeting", comment: "")
        let prompt = NSLocalizedString("support.mail.prompt", comment: "")
        let footer = String(
            format: NSLocalizedString("support.mail.footer", comment: ""),
            version, build, iOS
        )
        return "\(greeting)\n\n\(prompt)\n\n\(footer)"
    }
}
