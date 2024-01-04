//
//  Extensions.swift
//  Seamless
//
//  Created by Young Li on 11/19/23.
//
//  Source: https://www.youtube.com/watch?v=rDQ5ENvJxyc&t=99s
//  It's not working on scrollview, save for later modification.

import Foundation
import SwiftUI

extension View {
    // MARK: Extracting View's Height and Width with the help of hosting contoller and scrollview
    func convertToScrollView<Content: View>(@ViewBuilder content: @escaping ()->Content) -> UIScrollView {
        let scrollView = UIScrollView()
        
        // MARK: Converting SwiftUI View to UIKit View
        let hostingController = UIHostingController(rootView: content()).view!
        hostingController.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Constraints
        let constraints = [
            hostingController.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Width Anchor
            hostingController.widthAnchor.constraint(equalToConstant: screenBounds().width)
        ]
        scrollView.addSubview(hostingController)
        scrollView.addConstraints(constraints)
        scrollView.layoutIfNeeded()
        return scrollView
    }
    
    // MARK: Export to PDF - Completion Handler will send status and url
    func exportPDF<Content: View>(@ViewBuilder content: @escaping ()->Content, completion: @escaping (Bool, URL?) -> ()) {
        
        // MARK: To generate new file whenever its generated
        let outputFileUrl = defaultUrl.appendingPathComponent("SurveyListPDF - \(UUID().uuidString).pdf")
        
        // MARK: PDF View
        let pdfView = convertToScrollView {
            content()
        }
        pdfView.tag = 12345
        let size = pdfView.contentSize
        pdfView.frame = CGRect(x: 0, y: getSafeArea().top, width: size.width, height: size.height)
        
        // MARK: Attaching to root view and rendering the PDF
        getRootController().view.insertSubview(pdfView, at: 0)
        
        // MARK: Rendering PDF
        let render = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        do {
            try render.writePDF(to: outputFileUrl, withActions: { context in
                context.beginPage()
                pdfView.layer.render(in: context.cgContext)
            })
            
            completion(true, outputFileUrl)
        }
        catch {
            completion(false, nil)
            print("PDF ERROR: \(error.localizedDescription)")
        }
        
        // Removing the added View
        getRootController().view.subviews.forEach { view in
            if view.tag == 12345 {
                view.removeFromSuperview()
                print("Removed")
            }
        }
        
    }
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var urls: [Any]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
