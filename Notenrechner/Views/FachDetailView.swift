//
//  FachDetailView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 22.06.25.
//

import SwiftUI

struct FachDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var fach: Fach
    @AppStorage("klassenstufe") private var klassenstufe = 12
    
    @State private var viewModel = ViewModel()
    
    var deleteAction: (() -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    DurchschnittView(title: "Gesamt: ", average: viewModel.overallAverage, precision: -viewModel.precision)
                    DurchschnittView(title: "Mündlich: ", average: viewModel.oralAverage, precision: -viewModel.precision)
                    DurchschnittView(title: "Schriftlich: ", average: viewModel.writtenAverage, precision: -viewModel.precision)
                    
                } header: {
                    Text("Durchschnitte")
                }
                
                
                Section{
                    HStack {
                        Text("Fach:")
                            .font(.title3.bold())
                        
                        CustomTextField(
                            value: $fach.name,
                            placeholder: "Mathematik"
                        )
                    }
                    
                    HStack {
                        Text("Lehrer:")
                            .font(.title3.bold())
                        
                        CustomTextField(
                            value: $fach.teacher,
                            placeholder: "Frau Musterfrau"
                        )
                    }
                    
                    NotenScrollView(fach: fach, showWritten: false, title: "Mündliche Noten: ", label: "Ändere mündliche Note")

                    NotenScrollView(fach: fach, showWritten: true, title: "Schriftliche Noten: ", label: "Ändere schriftliche Note")
                } header: {
                    Text("Details")
//                        .font(.title3.bold())
                }
                
                Section {
                    HStack{
                        Text("Mündlich: ")
                            .font(.title3.bold())
                        CustomTextField(value: $fach.weighting, placeholder: "Prozentangabe")
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack{
                        Text("Schriftlich: ")
                            .font(.title3.bold())
                        Text("\((PercentDouble(1) - fach.weighting).stringValue)")
                    }
                } header: {
                    Text("Gewichtung")
                }
                
            }
            .onAppear {
                viewModel.updateFach(fach)
                viewModel.klassenstufe = klassenstufe
            }
            .onChange(of: fach) { _, newValue in
                viewModel.updateFach(newValue)
            }
            .onChange(of: klassenstufe) { _, newValue in
                viewModel.klassenstufe = newValue
            }
            .onChange(of: fach.oralGrades) {
                viewModel.updateOralAverage()
            }
            .navigationTitle(fach.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.settingsViewShowing.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Button{
                        viewModel.deleteAlertShowing = true
                    } label: {
                        Image(systemName: "trash.circle")
                            .foregroundStyle(.red)
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .sheet(isPresented: $viewModel.settingsViewShowing) {
                SettingsView()
            }
            .alert("Fach löschen?", isPresented: $viewModel.deleteAlertShowing) {
                Button("Löschen", role: .destructive) {
                    modelContext.delete(fach)
                    deleteAction()
                }
                
                Button("Abbrechen", role: .cancel){}
            } message: {
                Text("Wenn du das Fach löschst, werden alle Noten und Klausuren gelöscht.")
            }

        }
    }
}

#Preview {
    FachDetailView(fach: Fach.sampleData.first!) {}
}
