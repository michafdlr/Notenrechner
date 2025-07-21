//
//  ContentView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView(columnVisibility: $viewModel.columnVisibility) {
            List(viewModel.filteredFacher, selection: $viewModel.selectedFach) { fach in
                NavigationLink(fach.name, value: fach)
                    .onTapGesture {
                        viewModel.toggleColumnVisibility(fach: fach)
                    }
            }
            .navigationTitle("Fächer")
            .searchable(text: $viewModel.searchText, prompt: "Fach suchen")
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.fetchFacher()
            }
            .toolbar{
                Button{
                    viewModel.showAddFachSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        } detail: {
            if let fach = viewModel.selectedFach {
                FachDetailView(fach: fach) {
                    withAnimation{
                        viewModel.selectedFach = nil
                        viewModel.fetchFacher()
                    }
                }
            } else {
                VStack{
                    Text("Wähle ein Fach oder füge ein neues hinzu.")
                        .font(.title.bold())
                    
                    Button{
                        viewModel.showAddFachSheet = true
                    } label: {
                        HStack{
                            Image(systemName: "plus")
                                .font(.title.bold())
                            VStack(alignment: .leading){
                                Text("Fach")
                                Text("hinzufügen")
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .foregroundStyle(.white)
                        .background(Capsule())
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddFachSheet) {
            AddFachView { fach in
                viewModel.fetchFacher()
                viewModel.selectedFach = fach
                viewModel.toggleColumnVisibility(fach: fach)
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    ContentView(modelContext: SampleData.shared.modelContainer.mainContext)
        .modelContainer(SampleData.shared.modelContainer)
}
