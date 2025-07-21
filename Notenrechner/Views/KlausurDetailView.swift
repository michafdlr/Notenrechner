//
//  KlausurDetailView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 29.06.25.
//

import CryptoKit
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct KlausurDetailView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("klassenstufe") private var klassenstufe = 12
    @Bindable var klausur: Klausur
    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section("Basisinformationen") {
                    Picker(selection: $klausur.grade) {
                        ForEach(viewModel.notenRange, id: \.self) {
                            Text(
                                viewModel.notenRange.upperBound == 15
                                    && $0 < 10 ? "0\($0)" : String($0)
                            )
                            .monospaced()
                            .tag($0)
                        }
                    } label: {
                        Text("Klausurnote: ")
                            .bold()
                    }

                    DatePicker(
                        "Datum: ",
                        selection: $klausur.date,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                }

                Section("Klausurbilder") {
                    PhotosPicker(
                        selection: $viewModel.pickerItems,
                        selectionBehavior: .ordered
                    ) {
                        HStack {
                            Spacer()
                            Image(systemName: "photo.badge.plus.fill")
                            Text("Bilder hochladen")
                            Spacer()
                        }
                        .font(.title3)
                    }
                    .listRowBackground(Color.clear)

                    ImagesView(klausur: klausur)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onChange(of: viewModel.pickerItems) {
                            viewModel.multipleUploads = 0
                            Task {
                                for item in viewModel.pickerItems {
                                    if let image = try await item.loadTransferable(
                                        type: Image.self
                                    ) {
                                        let renderer = ImageRenderer(content: image)
                                        if let uiImage = renderer.uiImage,
                                            let data = uiImage.pngData()
                                        {
                                            let hash = SHA256.hash(data: data)
                                            let identifier = hash.compactMap {
                                                String(format: "%02x", $0)
                                            }.joined() + klausur.id.uuidString
                                            viewModel.multipleUploads +=
                                                klausur.handlePickedImage(
                                                    image,
                                                    identifier: identifier
                                                )
                                        }
                                    }
                                }

                                if viewModel.multipleUploads > 0 {
                                    viewModel.toast = Toast(
                                        style: .info,
                                        message:
                                            "\(viewModel.multipleUploads) Bilder waren bereits hochgeladen."
                                    )
                                } else {
                                    viewModel.toast = Toast(
                                        style: .success,
                                        message: "Bilder hochgeladen."
                                    )
                                }
                            }
                        }
                        .onAppear {
                            print(klausur.examImages.count)
                            viewModel.klassenstufe = klassenstufe
                            viewModel.refreshImages(from: klausur)
                        }
                        .onChange(of: klausur.examImages) { _, _ in
                            print("Loading images from klausur.examImages")
                            viewModel.refreshImages(from: klausur)
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Speichern") {
                        dismiss()
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Klausurergebnisse")
            .onChange(of: klassenstufe) { _, newValue in
                viewModel.klassenstufe = newValue
            }
            .toastView(toast: $viewModel.toast)
        }
    }
}

#Preview {
    KlausurDetailView(klausur: Klausur(grade: 12))
}
