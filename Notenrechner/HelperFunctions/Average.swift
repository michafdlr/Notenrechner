//
//  Average.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 24.06.25.
//

import Foundation

extension Array where Element == Int {
    func average(precision: Int? = nil) -> Decimal {
        if self.isEmpty {return 0.0}
        if let precision {
            return (self.reduce(0.0) {$0 + Double($1)}/Double(self.count)).roundTo(places: precision)
        }
        return self.reduce(0.0) {$0 + Decimal($1)}/Decimal(self.count)
    }
}

extension Double {
    ///round to places where places is the exponent of a power of 10
    func roundTo(places: Int) -> Decimal {
        Decimal((self / pow(10.0, Double(places))).rounded() * pow(10.0, Double(places)))
    }
}

extension Decimal {
    ///round to places where places is the exponent of a power of 10
    func roundTo(places: Int) -> Decimal {
        let double = (self as NSDecimalNumber).doubleValue
        return Decimal((double / pow(10.0, Double(places))).rounded() * pow(10.0, Double(places)))
    }
}

func overallAverage(oralAverage: Decimal, writtenAverage: Decimal, oralWeight: Decimal, precision: Int? = nil) -> Decimal {
    let preciseAverage = oralAverage*oralWeight + writtenAverage*(1-oralWeight)
    if let precision {
        return preciseAverage.roundTo(places: precision)
    }
    return preciseAverage
}
