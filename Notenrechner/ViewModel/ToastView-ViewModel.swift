//
//  ToastView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 09.07.25.
//

import SwiftUI

enum ToastStyle {
    case error, warning, success, info
    
    var themeColor: Color {
        switch self {
        case .error: .red
        case .warning: .orange
        case .success: .green
        case .info: .blue
        }
    }
    
    var iconName: String {
        switch self {
        case .error:
            "xmark.circle.fill"
        case .warning:
            "exclamationmark.circle.fill"
        case .success:
            "checkmark.circle.fill"
        case .info:
            "info.circle.fill"
        }
    }
}

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}
