//
//  EditNoteView.swift
//  Seamless
//
//  Created by Young Li on 11/1/23.
//
//  Source: https://www.youtube.com/watch?v=LR-ttBoa89M&t=144s
//          Apple documentation sample code: Drawing with PencilKit

import SwiftUI
import PencilKit

struct EditNoteView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var isNoteShown: Bool
    var survey: Survey
        
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    
    var body: some View {
        NavigationView {
            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color)
                .navigationTitle("Note")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        //  Allow Download / Upload functionalities
                        Button {
                            let imageSaver = SaveImage()
                            let savedImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
                            imageSaver.writeToPhotoAlbum(image: savedImage)
                        } label: {
                            Label(title: {Text("Download image")}, icon: { Image(systemName: "square.and.arrow.down") })
                        }
                        Button {
                            let uploadImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
                            uploadPhoto(survey: survey, uploadImage: uploadImage)
                        } label: {
                            Label(title: {Text("Upload")}, icon: { Image(systemName: "square.and.arrow.up") })
                        }
                        ColorPicker("Pick Color", selection: $color)
                            .labelsHidden()
                            .padding()
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            isDraw = false
                        } label: {
                            Label(title: {Text("Eraser")}, icon: { Image(systemName: "eraser") })
                        }
                        
                        //  Allow changing drawing tools
                        Menu {
                            Button {
                                isDraw = true
                                type = .pencil
                            } label: {
                                Label(title: {Text("Pencil")}, icon: { Image(systemName: "pencil.tip") })
                            }
                            Button {
                                isDraw = true
                                type = .pen
                            } label: {
                                Label(title: {Text("Pen")}, icon: { Image(systemName: "pencil.tip.crop.circle") })
                            }
                            Button {
                                isDraw = true
                                type = .marker
                            } label: {
                                Label(title: {Text("Marker")}, icon: { Image(systemName: "applepencil.and.scribble") })
                            }
                        } label: {
                            Label(title: {Text("Menu")}, icon: { Image(systemName: "list.bullet") })
                        }
                    }
                }
        }
    }
    
}

//  MARK: Drawing View Struct using Pencil Kit, UIViewRepresentable Protocol
struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    var ink: PKInkingTool {
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView , context: Context) {
        uiView.tool = isDraw ? ink : eraser
        
    }
}

#Preview {
    EditNoteView(isNoteShown: .constant(true), survey: Survey())
        .environmentObject(ModelData())
}
