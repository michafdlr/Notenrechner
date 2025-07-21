//
//  FachDetailView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 22.06.25.
//

import Foundation

extension FachDetailView {
    
    @Observable
    class ViewModel {
        var averageOralVisible = false
        var klassenstufe: Int? = nil
        var fach: Fach = Fach(name: "", teacher: "")
        var precision = -2
        
        var settingsViewShowing = false
        var deleteAlertShowing = false
        
        
        var notenRange: ClosedRange<Int> {
            guard let klassenstufe else {return 0...15}
            if klassenstufe < 11 {
                return 1...6
            }
            return 0...15
        }
        
        var writtenGrades: [Int] {
            fach.writtenKlausuren.map { $0.grade }
        }
        
        var oralAverage: Decimal = 0
        
        var writtenAverage: Decimal {
            var grades = [Int]()
            fach.writtenKlausuren.forEach { klausur in
                grades.append(klausur.grade)
            }
            return grades.average(precision: precision)
        }
        var overallAverage: Decimal {
            Notenrechner.overallAverage(oralAverage: oralAverage, writtenAverage: writtenAverage, oralWeight: Decimal(fach.weighting.value), precision: precision)
        }
        
        func updateFach(_ fach: Fach) {
            self.fach = fach
            updateOralAverage()
        }
        
        func updateOralAverage() {
            let oralGrades = fach.oralGrades.map { $0.value }
            oralAverage = oralGrades.average(precision: precision)
        }
    }
}
