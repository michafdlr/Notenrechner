//
//  DurchschnittView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 27.06.25.
//

import SwiftUI

extension DurchschnittView {
    @Observable
    class ViewModel {
        var klassenstufe = 12
        
        func getColor(_ avg: Decimal) -> Color {
            if klassenstufe > 10 {
                switch avg {
                case  ..<4.5: return .red
                case ..<6.5: return .orange
                case ..<9.5: return .yellow
                default: return .green
                }
            } else {
                switch avg {
                case ..<2.5: return .green
                case ..<3.5: return .yellow
                case ..<4.5: return .orange
                default: return .red
                }
            }
        }
    }
}

struct DurchschnittView: View {
    @AppStorage("klassenstufe") private var klassenstufe = 12
    var title: String
    var average: Decimal
    var precision: Int
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        HStack{
            Text(title)
                .font(.title3.bold())
            Text(average, format: .number.precision(.fractionLength(precision)))
                .padding(5)
                .foregroundStyle(
                    viewModel.getColor(average)
                )
                .fontWeight(.black)
                .shadow(color: .gray, radius: 3)
                .background(
                    .accent.opacity(0.7)
                , in: RoundedRectangle(cornerRadius: 5))
        }
        .onChange(of: klassenstufe) { _, newValue in
            viewModel.klassenstufe = newValue
        }
        .onAppear {
            viewModel.klassenstufe = klassenstufe
        }
    }
}

#Preview {
    DurchschnittView(title: "Gesamt: ", average: Decimal(6.6), precision: 2)
}
