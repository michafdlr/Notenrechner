//
//  NotenScrollView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 26.06.25.
//

import SwiftUI

struct NotenScrollView: View {
    @AppStorage("klassenstufe") private var klassenstufe = 12
    
    @Bindable var fach: Fach
    var showWritten = false
    var title: String
    var label: String
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    Text(title)
                        .font(.title3.bold())

                    Group{
                        if showWritten {
                            ForEach(fach.writtenKlausuren) { klausur in
                                let note = klausur.grade
                                Button {
                                    viewModel.selectedKlausur = klausur
                                } label: {
                                    Text(
                                        viewModel.notenRange.upperBound == 15 && note < 10
                                        ? "0\(note)" : String(note)
                                    )
                                    .padding(5)
                                    .frame(width: 40, height: 35)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.accent, lineWidth: 2.0)
                                        .overlay(
                                            Button {
                                                if let index = fach.writtenKlausuren.firstIndex(where: { $0.id == klausur.id }) {
                                                    fach.writtenKlausuren.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                            }
                                            .offset(x: 10, y: -10),
                                            alignment: .topTrailing
                                        )
                                )
                                .padding(10)
                                .sheet(item: $viewModel.selectedKlausur) {
                                    KlausurDetailView(klausur: $0)
                                }
                            }
                                Button {
                                    fach.writtenKlausuren.append(Klausur(grade: viewModel.notenRange.upperBound == 15 ? 10 : 2))
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                }
                                .buttonStyle(.plain)
                        } else {
                            ForEach($fach.oralGrades) { $grade in
                                Picker(selection: $grade.value) {
                                    ForEach(viewModel.notenRange, id: \.self) { note in
                                        Text(viewModel.notenRange.upperBound == 15 && note < 10 ? "0\(note)" : "\(note)")
                                            .tag(note)
                                    }
                                } label: {
                                    Text("Note")
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.accent, lineWidth: 2.0)
                                        .overlay(
                                            Button {
                                                if let index = fach.oralGrades.firstIndex(where: { $0.id == grade.id }) {
                                                    fach.oralGrades.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                            }
                                            .offset(x: 10, y: -10),
                                            alignment: .topTrailing
                                        )
                                )
                                .padding(10)
                            }
                            
                            Button {
                                fach.oralGrades.append(viewModel.notenRange.upperBound == 15 ? OralGrade(value: 10) : OralGrade(value: 2))
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Text("ø \(showWritten ? viewModel.getAverage(fach.writtenKlausuren.map { $0.grade }) : viewModel.getAverage(fach.oralGrades.map {$0.value}), format: .number.precision(.fractionLength(-viewModel.precision)))")
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
                        .foregroundStyle(.white.opacity(0.7))
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
            viewModel.klassenstufe = klassenstufe
        }
        .onChange(of: klassenstufe) { _, newValue in
            viewModel.klassenstufe = newValue
        }
    }
}

//#Preview {
//    NotenScrollView(grades: .constant([12, 14, 12]), klausuren: [], title: "Mündliche Noten: ", label: "Ändere mündliche Note")
//}
