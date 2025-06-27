//
//  SettingsView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("name") private var name = ""
    @AppStorage("klassenstufe") private var klassenstufe = 5
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form{
                HStack{
                    Text("Dein Name:")
                    CustomTextField(value: $name, placeholder: "Gib deinen Namen ein")
                }
                
                HStack{
                    Picker("Klassenstufe:", selection: $klassenstufe) {
                        ForEach(1...13, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Button("Speichern", systemImage: "square.and.arrow.down.fill") {
                    dismiss()
                }
            }
            .navigationTitle("Persönliches")
        }
    }
}

#Preview {
    SettingsView()
}
