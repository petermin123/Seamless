//
//  ScannerView.swift
//  Seamless
//
//  Created by Young Li on 11/12/23.
//
//  Source: https://www.youtube.com/watch?v=QHouskATQ5U
//          https://github.com/twostraws/CodeScanner

import SwiftUI
import CodeScanner

struct ScannerView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a QR code to get started."
    
    //  QR Code Scanner View
    var scannedSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    self.isPresentingScanner = false
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if scannedCode != "" {
                    Text(scannedCode)
                }
                
                Button("Scan QR code") {
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner, onDismiss: {
                    print(self.isPresentingScanner)
                    print(self.scannedCode)
                }) {
                    self.scannedSheet
                }
                
                if scannedCode != "Scan a QR code to get started." {
                    NavigationLink {
                        SurveyListView(searchText: String(scannedCode.prefix(8)), postQRCodeScan: false)
                    } label: {
                        Text("Go to SurveyList")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ScannerView()
}
