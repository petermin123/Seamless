//
//  SaveQRCodeImage.swift
//  Seamless
//
//  Created by Young Li on 10/30/23.
//
//  Source: https://www.youtube.com/watch?v=q-eQWNsutjY

import SwiftUI
import Photos
import UIKit

class SaveImage: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
