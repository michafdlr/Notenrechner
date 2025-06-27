//
//  Fach.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import Foundation
import SwiftData

@Model
class Fach {
    var name: String
    var teacher: String
    var oralGrades: [Int]
    var writtenKlausuren: [Klausur]
    var weighting: Double
    
    init(name: String, teacher: String, oralGrades: [Int] = [], writtenKlausuren: [Klausur] = [], weighting: Double = 0.5) {
        self.name = name
        self.teacher = teacher
        self.oralGrades = oralGrades
        self.writtenKlausuren = writtenKlausuren
        self.weighting = weighting
    }
    
    static let sampleData = [
        Fach(name: "Mathe", teacher: "Herr Fiedler", oralGrades: [13, 12, 14], writtenKlausuren: [Klausur(grade: 9), Klausur(grade: 11)]),
        Fach(name: "Deutsch", teacher: "Frau Waluga"),
        Fach(name: "Englisch", teacher: "Herr Meier")
    ]
}
