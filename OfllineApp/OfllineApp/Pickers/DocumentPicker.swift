//
//  DocumentPicker.swift
//  OfllineApp
//
//  Created by Arya Vashisht on 30/05/24.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
  @Binding var files: [FileRecord]
  
  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.image])
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIDocumentPickerDelegate {
    let parent: DocumentPicker
    
    init(_ parent: DocumentPicker) {
      self.parent = parent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      guard let url = urls.first else { return }
      let dbHelper = DatabaseHelper()
      let fileHelper = FileHelper()
      fileHelper.loadThumbnail(for: url) { [weak self] thumbnailImage in
        guard let self else { return }
        dbHelper.saveFile(
          fileUrl: url,
          thumbnailImage: thumbnailImage
        )
        parent.files = dbHelper.fetchFiles()
      }
    }
  }
}
