//
//  ImageView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 11.07.25.
//

import SwiftUI

extension Image: @retroactive Identifiable {
    public var id: String {
        UUID().uuidString
    }
}

struct ImagesView: View {
    var klausur: Klausur
    @State private var toast: Toast? = nil
    @State private var selectedImage: Image? = nil
    @State private var imageShowing = false

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(klausur.examImages, id: \.self) { path in
                    if let image = klausur.loadImage(from: path) {
                        Button {
                            selectedImage = image
                            imageShowing = true
                        } label: {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray.opacity(0.8), lineWidth: 3)
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                toast = klausur.deleteImage(from: path)
                                            } label: {
                                                Image(systemName: "xmark.circle")
                                                    .foregroundStyle(.red)
                                                    .font(.title.bold())
                                                    .background(.gray.opacity(0.8))
                                                    .clipShape(Circle())
                                            }
                                            .offset(x: 10, y: -10)
                                        }
                                )
                        }
                    }
                }
            }
            .padding(.vertical)
            .fullScreenCover(item: $selectedImage) { image in
                SingleImageView(image: image)
            }
        }
    }
}
