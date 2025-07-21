//
//  AddFachView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 13.07.25.
//

import SwiftUI
import SwiftData

extension AddFachView {
    @Observable
    class ViewModel {
        var name = ""
        var teacher = ""
        var weighting = PercentDouble(0.5)
        
        func addFachTo(modelContext: ModelContext) -> Fach {
            let fach = Fach(name: name, teacher: teacher, weighting: weighting)
            modelContext.insert(fach)
            return fach
        }
    }
}

struct AddFachView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel = ViewModel()
    var onSave: ((Fach) -> Void)
    
    var body: some View {
        NavigationStack{
            List {
                HStack {
                    Text("Fach: ")
                        .font(.title2.bold())
                    CustomTextField(value: $viewModel.name, placeholder: "Mathematik", width: 300)
                }
                
                HStack{
                    Text("Lehrer: ")
                        .font(.title2.bold())
                    CustomTextField(value: $viewModel.teacher, placeholder: "Name", width: 300)
                }
                
                HStack {
                    Text("Mündliche Gewichtung: ")
                        .font(.title2.bold())
                    
                    CustomTextField(value: $viewModel.weighting, placeholder: "50 %", width: 150)
                }
                
                HStack{
                    Spacer()
                    
                    Button{
                        let fach = viewModel.addFachTo(modelContext: modelContext)
                        onSave(fach)
                        dismiss()
                    } label: {
                        Text("Hinzufügen")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Capsule())
                    }
                    .disabled(viewModel.name.isEmpty)
                    
                    Spacer()
                }
                .padding(.top)
                .listRowBackground(Color.clear)
            }
            .navigationTitle(viewModel.name.isEmpty ? "Neues Fach" : viewModel.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        let fach = viewModel.addFachTo(modelContext: modelContext)
                        onSave(fach)
                        dismiss()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .disabled(viewModel.name.isEmpty)
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "trash.circle")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    AddFachView() {_ in}
}
