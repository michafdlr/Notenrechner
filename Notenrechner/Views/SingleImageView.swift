//
//  SingleImageView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 12.07.25.
//

import SwiftUI

struct SingleImageView: View {
    @Environment(\.dismiss) var dismiss
    
    var image: Image
    
    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack{
            image
                .resizable()
                .scaledToFit()
                .scaleEffect(viewModel.totalZoom + viewModel.currentZoom)
                .simultaneousGesture(
                    MagnifyGesture()
                        .onChanged { value in
                            viewModel.currentZoom = value.magnification - 1
                        }
                        .onEnded { value in
                            viewModel.totalZoom += viewModel.currentZoom
                            viewModel.currentZoom = 0
                        }
                )
                .accessibilityZoomAction { action in
                    if action.direction == .zoomIn {
                        viewModel.totalZoom += 1
                    } else {
                        viewModel.totalZoom -= 1
                    }
                }
                .offset(viewModel.offset)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged{ value in
                            viewModel.offset = value.translation
                        }
                )
                .rotationEffect(viewModel.angle)
                .simultaneousGesture(
                    RotateGesture()
                        .onChanged{ value in
                            viewModel.angle = value.rotation
                        }
                )
                .toolbar{
                    ToolbarItem(placement: .primaryAction){
                        Button{
                            withAnimation{
                                viewModel.resize(image: image)
                            }
                        } label: {
                            Image(systemName: "arrow.down.left.and.arrow.up.right.rectangle")
                                .font(.title2.bold())
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button{
                            viewModel.angle -= Angle(degrees: 90)
                        } label: {
                            Image(systemName: "rotate.left")
                                .font(.title2.bold())
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button{
                            viewModel.angle += Angle(degrees: 90)
                        } label: {
                            Image(systemName: "rotate.right")
                                .font(.title2.bold())
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button{
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.title2.bold())
                        }
                    }
                }
        }
    }
}

#Preview {
    SingleImageView(image: Image(systemName: "photo.artframe"))
}
