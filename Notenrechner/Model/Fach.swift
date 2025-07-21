//
//  Fach.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import Foundation
import SwiftData

struct OralGrade: Identifiable, Codable, Hashable {
    var id = UUID()
    var value: Int
}

@Model
class Fach {
    var name: String
    var teacher: String
    var oralGrades: [OralGrade]
    @Relationship(deleteRule: .cascade) var writtenKlausuren: [Klausur]
    var weighting: PercentDouble
    
    init(name: String, teacher: String, oralGrades: [OralGrade] = [], writtenKlausuren: [Klausur] = [], weighting: PercentDouble = PercentDouble(0.5)) {
        self.name = name
        self.teacher = teacher
        self.oralGrades = oralGrades
        self.writtenKlausuren = writtenKlausuren
        self.weighting = weighting
    }
    
    static let sampleData = [
        Fach(name: "Mathe", teacher: "Herr Fiedler", oralGrades: [OralGrade(value: 13), OralGrade(value: 14), OralGrade(value: 9)], writtenKlausuren: [Klausur(grade: 9), Klausur(grade: 11)]),
        Fach(name: "Deutsch", teacher: "Frau Waluga"),
        Fach(name: "Englisch", teacher: "Herr Meier")
    ]
}
