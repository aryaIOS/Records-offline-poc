//
//  FileRecord.swift
//  OfllineApp
//
//  Created by Arya Vashisht on 30/05/24.
//

import UIKit

struct FileRecord: Identifiable {
  let id: Int64
  let name: String
  let url: String
  let thumbnailData: Data
}
