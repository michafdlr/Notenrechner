//
//  Exam.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Klausur: Identifiable {
    var id: UUID
    var grade: Int
    var date: Date
    var examImages: [String]
    
    init(grade: Int, date: Date = .now, examImages: [String] = []) {
        self.id = UUID()
        self.grade = grade
        self.date = date
        self.examImages = examImages
    }
    
    
    func loadImage(from relativePath: String) -> Image? {
        let fullPath = URL.documentsDirectory.appendingPathComponent(relativePath).path
        if let uiImage = UIImage(contentsOfFile: fullPath) {
            return Image(uiImage: uiImage)
        } else {
            print("❌ Could not load image at path: \(fullPath)")
            return nil
        }
    }
    
    func deleteImage(from relativePath: String) -> Toast {
        let fullPath = URL.documentsDirectory.appending(path: relativePath).path
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: fullPath)
            if let index = examImages.firstIndex(where: { path in
                path == relativePath
            }) {
                examImages.remove(at: index)
            }
            print("Bild unter \(fullPath) erfolgreich gelöscht.")
            return Toast(style: .success, message: "Bild erfolgreich gelöscht.")
        } catch {
            print(error.localizedDescription)
            return Toast(style: .error, message: "Bild konnte nicht gelöscht werden.")
        }
    }
    
    @MainActor
    func handlePickedImage(_ image: Image, identifier: String) -> Int {
        let fileManager = FileManager.default
        let imagesDirectory = URL.documentsDirectory.appendingPathComponent("images")
        let filename = "\(identifier).png"
        let fileURL = imagesDirectory.appendingPathComponent(filename)

        if fileManager.fileExists(atPath: fileURL.path) && examImages.contains(where: { path in
            path == "images/\(filename)"
        }) {
            return 1
        }

        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: imagesDirectory.path) {
            do {
                try fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
            } catch {
                print("❌ Failed to create images directory: \(error.localizedDescription)")
                return 0
            }
        }

        // Render and save image
        let renderer = ImageRenderer(content: image)
        if let uiImage = renderer.uiImage, let data = uiImage.pngData() {
            do {
                try data.write(to: fileURL, options: [.atomic])
                print("✅ Image file saved at: \(fileURL.path)")

                let relativePath = "images/\(filename)"
                examImages.append(relativePath)
                return 0
            } catch {
                print("❌ Error writing image data: \(error.localizedDescription)")
                return 1
            }
        }

        return 0
    }
}
