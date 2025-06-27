//
//  FachDetailView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 22.06.25.
//

import SwiftUI

struct FachDetailView: View {
    var fach: Fach
    @AppStorage("klassenstufe") private var klassenstufe = 12
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Gesamt: \(viewModel.overallAverage)")
                    Text("Mündlich: \(viewModel.oralAverage)")
                    Text("Schriftlich: \(viewModel.writtenAverage)")
                    
                } header: {
                    Text("Durchschnitte")
                        .font(.title3.bold())
                }
                
                
                Section{
                    HStack {
                        Text("Lehrer:")
                            .font(.title3.bold())
                        
                        CustomTextField(
                            value: $viewModel.fach.teacher,
                            placeholder: "Frau Musterfrau"
                        )
                    }
                    
                    NotenScrollView(grades: viewModel.fach.oralGrades, title: "Mündliche Noten: ", label: "Ändere mündliche Note")
                    
                    NotenScrollView(grades: viewModel.writtenGrades, title: "Schriftliche Noten: ", label: "Ändere schriftliche Note")
                } header: {
                    Text("Details")
                        .font(.title3.bold())
                }
                
            }
            .onAppear {
                viewModel.updateFach(fach)
                viewModel.klassenstufe = klassenstufe
            }
            .onChange(of: fach) { oldValue, newValue in
                viewModel.updateFach(newValue)
            }
            .onChange(of: klassenstufe) { _, newValue in
                viewModel.klassenstufe = newValue
            }
            .navigationTitle(viewModel.fach.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.settingsViewShowing.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .sheet(isPresented: $viewModel.settingsViewShowing) {
                SettingsView()
            }
        }
    }
}

#Preview {
    FachDetailView(fach: Fach.sampleData.first!)
}
