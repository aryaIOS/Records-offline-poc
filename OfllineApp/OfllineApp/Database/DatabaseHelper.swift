//
//  DatabaseHelper.swift
//  OfllineApp
//
//  Created by Arya Vashisht on 30/05/24.
//

import SQLite
import Foundation
import UIKit

class DatabaseHelper: ObservableObject {
  
  var db: Connection?
  let filesTable = Table("files")
  let id = Expression<Int64>("id")
  let name = Expression<String>("name")
  let url = Expression<String>("url")
  let thumbnailData = Expression<Data>("thumbnailData")
  
  init() {
    setupDatabase()
  }
  
  func setupDatabase() {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    print("Database path: \(path)/db.sqlite3")
    
    do {
      db = try Connection("\(path)/db.sqlite3")
      
      if !UserDefaults.standard.bool(forKey: "is_db_created") {
        try db?.run(filesTable.create(ifNotExists: true) { t in
          t.column(id, primaryKey: .autoincrement)
          t.column(name)
          t.column(url)
          t.column(thumbnailData)
        })
        UserDefaults.standard.set(true, forKey: "is_db_created")
        print("Database created successfully.")
      } else {
        print("Database already created.")
      }
      
    } catch {
      print("Unable to setup database: \(error)")
    }
  }
  
  func saveFile(
    fileUrl: URL,
    thumbnailImage: UIImage?
  ) {
    guard let thumbnailImageData = thumbnailImage?.jpegData(compressionQuality: 0.4) else {
      print("Unable to generate thumbnail data")
      return
    }
    do {
      try db?.run(
        filesTable.insert(
          name <- fileUrl.lastPathComponent,
          url <- fileUrl.absoluteString,
          thumbnailData <- thumbnailImageData
        )
      )
    } catch {
      print("Unable to save file: \(error)")
    }
  }
  
  func fetchFiles() -> [FileRecord] {
    var records: [FileRecord] = []
    
    guard let db = db else {
      print("Database is nil. Cannot fetch files.")
      return records
    }
    
    do {
      let query = filesTable.order(id.desc)
      for file in try db.prepare(query) {
        records.append(
          FileRecord(
            id: file[id],
            name: file[name],
            url: file[url],
            thumbnailData: file[thumbnailData]
          )
        )
      }
    } catch {
      print("Unable to fetch files: \(error)")
    }
    
    return records
  }
  
  func deleteFile(_ file: FileRecord) {
    do {
      let fileToDelete = filesTable.filter(id == file.id)
      try db?.run(fileToDelete.delete())
      try FileManager.default.removeItem(atPath: file.url)
    } catch {
      print("Unable to delete file: \(error)")
    }
  }
}
