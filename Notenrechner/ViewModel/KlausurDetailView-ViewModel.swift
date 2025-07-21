//
//  KlausurDetailView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 29.06.25.
//

import PhotosUI
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

extension KlausurDetailView {
    @Observable
    class ViewModel {
        var klassenstufe: Int? = nil
        var hasPremium = true
        var pickerItems: [PhotosPickerItem] = []
        var documentImporterPresent = false
        var picturesAlreadyUploadedAlert = false
        var toast: Toast? = nil
        var multipleUploads = 0

        var selectedImages = [Image]()

        var notenRange: ClosedRange<Int> {
            guard let klassenstufe else { return 0...15 }
            if klassenstufe < 11 {
                return 1...6
            }
            return 0...15
        }

        func handlePickedFile(_ url: URL) {
            print(url)
        }

        func loadImage(_ path: String) -> UIImage? {
            return UIImage(contentsOfFile: path)
        }
        
        @MainActor
        func refreshImages(from klausur: Klausur) {
            print("refreshing images")
            selectedImages = klausur.examImages.compactMap { path in
                if let uiImage = loadImage(path) {
                    return Image(uiImage: uiImage)
                }
                return nil
            }
        }
    }
}
