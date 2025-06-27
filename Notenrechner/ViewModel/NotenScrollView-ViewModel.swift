//
//  NotenScrollView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 26.06.25.
//

import Foundation

extension NotenScrollView {
    
    @Observable
    class ViewModel {
        var grades = [Int]()
        var klassenstufe: Int? = nil
        var averageVisible = false
        var precision = -2
        
        var notenRange: ClosedRange<Int> {
            guard let klassenstufe else {return 0...15}
            if klassenstufe < 11 {
                return 1...6
            }
            return 0...15
        }
        
        var average: Decimal {
            grades.average(precision: precision)
        }
    }
}
