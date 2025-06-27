//
//  ContentView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 21.06.25.
//

import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        var selectedFach: Fach?
        var columnVisibility = NavigationSplitViewVisibility.automatic
        
        func toggleColumnVisibility(fach: Fach) {
            selectedFach = fach
            columnVisibility = .detailOnly
        }
    }
}
