//
//  FileHelpers.swift
//  OfllineApp
//
//  Created by Arya Vashisht on 30/05/24.
//

import UIKit

class FileHelper {
  func loadThumbnail(
    for documentURL: URL,
    completion: @escaping (UIImage?) -> Void
  ) {
    // Example: Check if the URL is a PDF file
    if documentURL.pathExtension == "pdf" {
      // Generate a thumbnail for PDF
      if let thumbnail = generateThumbnailForPDF(at: documentURL) {
        completion(thumbnail)
      }
    }
  }
  
  func generateThumbnailForPDF(at url: URL) -> UIImage? {
    guard let pdfDocument = CGPDFDocument(url as CFURL) else {
      return nil
    }
    
    guard let firstPage = pdfDocument.page(at: 1) else {
      return nil
    }
    
    let pageRect = firstPage.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    
    let thumbnail = renderer.image { context in
      UIColor.white.set()
      context.fill(pageRect)
      
      context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
      context.cgContext.scaleBy(x: 1.0, y: -1.0)
      
      context.cgContext.drawPDFPage(firstPage)
    }
    
    return thumbnail
  }
}
