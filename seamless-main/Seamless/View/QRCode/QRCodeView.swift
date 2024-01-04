//
//  QRCodeView.swift
//  Seamless
//
//  Created by Young Li on 10/30/23.
//
//  Source: https://www.youtube.com/watch?v=HD_Fobpwt4M

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins

struct QRCode {
    let uuidString: String
    let uiImage: UIImage
}

struct QRCodeView: View {
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var surveyId: UUID
    //  The QRCode is generated based on the given UUID().uuidString
    @State var qrcode: QRCode = QRCode(uuidString: UUID().uuidString, uiImage: UIImage())
    
    var body: some View {
        VStack {
            Text(qrcodeTitle)
              .font(
                Font.custom("Gluten", size: 32)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
              .frame(width: 393, alignment: .top)
            
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 354, height: 527)
                  .background(Color(red: 0.91, green: 0.97, blue: 0.98))
                  .cornerRadius(18)
                
                VStack {
                    Text(qrcodeInstruction)
                      .font(
                        Font.custom("Montserrat-Bold", size: 24)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.15, green: 0.78, blue: 0.67))
                      .frame(width: 312, height: 153, alignment: .top)
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 247, height: 273)
                      .background(
                        Image(uiImage: qrcode.uiImage)
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 200, height: 200)
                          .clipped()
                      )
                }
            }
            .padding()
            
            Button {
                let imageSaver = SaveImage()
                let savedImage = qrcode.uiImage
                imageSaver.writeToPhotoAlbum(image: savedImage)
            } label: {
                ButtonView(text: qrcodeDownload)
                    .padding()
            }
            
            NavigationLink {
                HomePageView(survey: Survey())
            } label: {
                ButtonView(text: homeStr)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            qrcode = returnData(str: surveyId.uuidString) ?? QRCode(uuidString: UUID().uuidString, uiImage: UIImage())
        }
    }
    
    //  QR Code Generator
    func returnData(str: String) -> QRCode? {
        let data = str.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let image = filter.outputImage?.transformed(by: transform) {
            if let cgImage = context.createCGImage(image, from: image.extent) {
                let qrCode = QRCode(uuidString: surveyId.uuidString, uiImage: UIImage(cgImage: cgImage))
                return qrCode
            }
        }
        return nil
    }
}

#Preview {
    QRCodeView(surveyId: UUID())
}
