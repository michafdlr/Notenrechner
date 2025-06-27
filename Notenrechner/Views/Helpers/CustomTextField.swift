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
    var stringValue: String { get {self} set { self = newValue }}
    init?(from string: String) {
        self = string
    }
}

extension Int: CustomTextFieldValue {
    var stringValue: String { get { "\(self)" } set { self = Int(newValue) ?? 0 }}
    init?(from string: String) {
        self = Int(string) ?? 0
    }
}

struct CustomTextField<T: CustomTextFieldValue>: View {
    @Binding var value: T
    var placeholder: String
    var lineWidth = 2.0
    var cornerRadius = 8.0
    var bgColor = Color.clear
    
    @State private var internalText: String = ""
    
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
        .onChange(of: internalText) {_, newValue in
            if let converted = T(from: newValue) {
                value = converted
            }
        }
    }
}

#Preview {
    CustomTextField(value: .constant(5), placeholder: "Placeholder")
        .padding()
}
