//
//  Exam.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import Foundation
import SwiftData

@Model
class Klausur: Identifiable {
    var id: UUID
    var grade: Int
    var examImages: [String]?
    
    init(grade: Int, examImages: [String]? = nil) {
        self.id = UUID()
        self.grade = grade
        self.examImages = examImages
    }
}
