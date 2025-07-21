//
//  ToastView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 09.07.25.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var duration: Double = 3.0
    var width: Double = .infinity
    var onCancelTapped: (() -> Void) = {}

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: style.iconName)
                .font(.title3)
                .foregroundStyle(style.themeColor)

            Text(message)
                .font(.caption)

            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundStyle(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(.gray, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 3)
                .foregroundStyle(style.themeColor)
        )
        .padding(.horizontal, 10)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                mainToastView()
                    .animation(.spring(), value: toast)
            )
            .onChange(of: toast) {
                showToast()
            }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    duration: toast.duration,
                    width: toast.width
                ) {
                    dismissToast()
                }
                Spacer()
            }
        }
    }

    private func showToast() {
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        if toast.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
                dismissToast()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(
                deadline: .now() + toast.duration,
                execute: task
            )
        }
    }

    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    @Previewable @State var toast: Toast? = nil
    Button {
        toast = Toast(style: .error, message: "Bilder konnten nicht gespeichert werden")
    } label: {
        Text("Toast")
    }
    .toastView(toast: $toast)
}
