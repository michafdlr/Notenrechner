//
//  NotenScrollView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 26.06.25.
//

import SwiftUI

extension NotenScrollView {
    
    @Observable
    class ViewModel {
        var klassenstufe: Int? = nil
        var averageVisible = false
        var precision = -2
        var selectedKlausur: Klausur? = nil
        
        var notenRange: ClosedRange<Int> {
            guard let klassenstufe else {return 0...15}
            if klassenstufe < 11 {
                return 1...6
            }
            return 0...15
        }
        
        func getAverage(_ grades: [Int]) -> Decimal {
            grades.average(precision: precision)
        }
    }
}
