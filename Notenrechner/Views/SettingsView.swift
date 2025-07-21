//
//  SettingsView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("name") private var name = ""
    @AppStorage("klassenstufe") private var klassenstufe = 12
    
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
                
                HStack{
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Speichern")
                        }
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Capsule())
                    }
                    
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Persönliches")
        }
    }
}

#Preview {
    SettingsView()
}
