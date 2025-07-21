//
//  CustomTextField.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 23.06.25.
//

import SwiftUI

protocol CustomTextFieldValue {
    var stringValue: String { get set }
    init?(from string: String)
}

extension String: CustomTextFieldValue {
    var stringValue: String {
        get { self }
        set { self = newValue }
    }
    init?(from string: String) {
        self = string
    }
}

extension Int: CustomTextFieldValue {
    var stringValue: String {
        get { "\(self)" }
        set { self = Int(newValue) ?? 0 }
    }
    init?(from string: String) {
        self = Int(string) ?? 0
    }
}

extension Double: CustomTextFieldValue {
    var stringValue: String {
        get { "\(self)" }
        set { self = Double(newValue) ?? 0.0 }
    }
    init?(from string: String) {
        self = Double(string) ?? 0
    }
}

struct PercentDouble: Codable, CustomTextFieldValue {
    var value: Double

    var stringValue: String {
        get { "\(value.formatted(.percent.precision(.fractionLength(2))))" }
        mutating set {
            let cleaned = newValue.replacingOccurrences(of: "%", with: "")
                .replacingOccurrences(of: ",", with: ".")
                .trimmingCharacters(in: .whitespaces)

            if let number = Double(cleaned) {
                let clamped = min(max(number, 0), 100)
                self.value = clamped / 100.0
            } else {
                self.value = 0
            }
        }
    }

    init?(from string: String) {
        let cleaned = string.replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)

        if let number = Double(cleaned) {
            let clamped = min(max(number, 0), 100)
            self.value = clamped / 100.0
        } else {
            return nil
        }
    }

    // Optional: default init
    init(_ value: Double) {
        let clamped = min(max(value, 0), 100)
        self.value = clamped
    }
    
    static func -(lhs: PercentDouble, rhs: PercentDouble) -> PercentDouble {
        PercentDouble(lhs.value - rhs.value)
    }
}

struct CustomTextField<T: CustomTextFieldValue>: View {
    @Binding var value: T
    var placeholder: String
    var lineWidth = 2.0
    var cornerRadius = 8.0
    var bgColor = Color.clear
    var width: CGFloat? = nil

    @State var internalText: String = ""

    var body: some View {
        TextField(placeholder, text: $internalText)
            .padding(5)
            .background(bgColor)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: lineWidth)
                    .foregroundStyle(.accent)
            )
            .onAppear {
                internalText = value.stringValue
            }
            .onChange(of: value.stringValue) { _, newValue in
                internalText = newValue
            }
            .onChange(of: internalText) { _, newValue in
                if let converted = T(from: newValue) {
                    value = converted
                }
            }
            .onSubmit {
                if let converted = T(from: internalText) {
                    value = converted
                    internalText = value.stringValue
                }
            }
            .frame(width: width)
    }
}

#Preview {
    CustomTextField(value: .constant(5), placeholder: "Placeholder", width: 100)
        .padding()
}
