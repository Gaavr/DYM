//
//  ExportError.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.02.2026.
//


import Foundation
import ZIPFoundation

enum PostersZipExporter {
    private static let fm = FileManager.default
    
    static func makeZip(
        categoryName: String,
        posters: [Poster]
    ) throws -> URL {
        
        guard !posters.isEmpty else { throw ExportError.noPosters }
        
        // temp folder
        let baseFolder = fm.temporaryDirectory
            .appendingPathComponent("DYM_Export", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        
        try fm.createDirectory(at: baseFolder, withIntermediateDirectories: true)
        
        // write images
        var writtenFiles: [URL] = []
        for poster in posters {
            guard let data = poster.imageData else { continue }
            
            let ext = detectFileExtension(data) ?? "jpg"
            let safeName = safeFilename(poster.name)
            let fileURL = baseFolder.appendingPathComponent("\(safeName).\(ext)")
            
            try data.write(to: fileURL, options: [.atomic])
            writtenFiles.append(fileURL)
        }
        
        guard !writtenFiles.isEmpty else { throw ExportError.missingImageData }
        
        // zip url
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let zipName = "DYM_v\(version)_\(safeFilename(categoryName))_\(timestamp()).zip"
        let zipURL = fm.temporaryDirectory.appendingPathComponent(zipName)
        
        // remove previous if exists
        if fm.fileExists(atPath: zipURL.path) {
            try fm.removeItem(at: zipURL)
        }
        
        // create zip
        let archive = try Archive(url: zipURL, accessMode: .create)
        
        for fileURL in writtenFiles {
            let entryName = fileURL.lastPathComponent
            try archive.addEntry(
                with: entryName,
                fileURL: fileURL,
                compressionMethod: .deflate
            )
        }
        
        return zipURL
    }
    
    // MARK: - Helpers
    
    private static func detectFileExtension(_ data: Data) -> String? {
        if data.count >= 8 {
            let sig = [UInt8](data.prefix(8))
            if sig == [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] { return "png" }
        }
        if data.count >= 3 {
            let sig = [UInt8](data.prefix(3))
            if sig[0] == 0xFF, sig[1] == 0xD8, sig[2] == 0xFF { return "jpg" }
        }
        return nil
    }
    
    private static func safeFilename(_ s: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(.init(charactersIn: "_-"))
        return s.unicodeScalars
            .map { allowed.contains($0) ? Character($0) : "_" }
            .reduce("") { $0 + String($1) }
    }
    
    private static func timestamp() -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f.string(from: .now).replacingOccurrences(of: ":", with: "-")
    }
}

enum ExportError: Error {
    case noPosters
    case missingImageData
}
