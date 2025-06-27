//
//  NotenScrollView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 26.06.25.
//

import SwiftUI

struct NotenScrollView: View {
    @AppStorage("klassenstufe") private var klassenstufe = 12
    
    var grades: [Int]
    var title: String
    var label: String
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    Text(title)
                        .font(.title3.bold())

                    ForEach(0..<viewModel.grades.count, id: \.self) {
                        index in
                        Picker(selection: $viewModel.grades[index]) {
                            ForEach(viewModel.notenRange, id: \.self) {
                                Text(
                                    viewModel.notenRange.upperBound == 15
                                        && $0 < 10 ? "0\($0)" : String($0)
                                )
                                .monospaced()
                            }
                        } label: {
                            Text("\(label) \(index+1)")
                            Text("Note \(viewModel.grades[index])")
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.accent, lineWidth: 2.0)
                        )
                        .padding(.vertical, 5)
                    }

                    Button {

                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }

                    Text("ø \(viewModel.average)")
                        .font(.title3.bold())
                        .onScrollVisibilityChange(threshold: 0.9) { bool in
                            withAnimation(.spring(duration: 0.5)) {
                                viewModel.averageVisible = bool
                            }
                        }
                }

            }
            if !viewModel.averageVisible {
                HStack {
                    Spacer()
                    Image(systemName: "arrowshape.forward.fill")
                        .font(.title3.bold())
                        .foregroundStyle(.primary.opacity(0.8))
                        .shadow(color: .secondary, radius: 3)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.accent.opacity(0.9))
                                .blur(radius: 5)
                        )
                }

            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.grades = grades
            viewModel.klassenstufe = klassenstufe
        }
        .onChange(of: grades) { _, newValue in
            viewModel.grades = grades
        }
        .onChange(of: klassenstufe) { _, newValue in
            viewModel.klassenstufe = newValue
        }
    }
}

#Preview {
    NotenScrollView(grades: [12, 14, 12], title: "Mündliche Noten: ", label: "Ändere mündliche Note")
}
