//
//  SingleImageView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 13.07.25.
//

import SwiftUI

extension SingleImageView {
    @Observable
    class ViewModel {
        var currentZoom = 0.0
        var totalZoom = 1.0
        var offset: CGSize = .zero
        var angle: Angle = .zero
        
        func resize(image: Image) {
            currentZoom = 0.0
            totalZoom = 1.0
            offset = .zero
            angle = .zero
        }
    }
}
