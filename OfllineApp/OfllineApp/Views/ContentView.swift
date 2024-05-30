//
//  ContentView.swift
//  OfllineApp
//
//  Created by Arya Vashisht on 30/05/24.
//

import SwiftUI

struct ContentView: View {
  @State private var showingImagePicker = false
  @State private var showingDocumentPicker = false
  @State private var files: [FileRecord] = []
  @StateObject private var dbHelper = DatabaseHelper()
  
  var body: some View {
    ZStack {
      Color(.yellow).edgesIgnoringSafeArea(.all)
      /// Files List
      List {
        ForEach(files, id: \.id) { file in
          /// File row item
          VStack(spacing: 10) {
            if let thumbnailImage = UIImage(data: file.thumbnailData) {
              Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped(antialiased: true)
                .alignmentGuide(.top) { _ in 0 }
            }
            Text(file.name)
          }
          .swipeActions {
            Button(role: .destructive) {
              deleteFile(file)
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
        }
      }
      .listStyle(.plain)
      
      /// Upload Button
      VStack {
        Spacer()
        HStack {
          Spacer()
          HStack {
            Image(systemName: "plus")
            Text("Upload")
          }
          .padding()
          .background(Color.white)
          .border(Color.black)
          .contentShape(Rectangle())
          .onTapGesture {
            showingDocumentPicker = true
          }
          .padding(.bottom, 40)
          .padding(.trailing, 16)
        }
      }
      .edgesIgnoringSafeArea(.all)
    }
    .sheet(isPresented: $showingDocumentPicker, content: {
      DocumentPicker(files: $files)
    })
    .onAppear {
      /// Fetch files when ContentView appears
      files = dbHelper.fetchFiles()
    }
  }
  
  func deleteFile(_ file: FileRecord) {
    // Delete the file from database and update the list
    let dbHelper = DatabaseHelper()
    dbHelper.deleteFile(file)
    files = dbHelper.fetchFiles()
  }
}
