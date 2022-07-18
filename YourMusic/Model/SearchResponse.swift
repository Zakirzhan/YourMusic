//
//  SearchResponse.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//

import Foundation

struct SearchResponse: Decodable {
   let resultCount: Int
   let results: [Track]
}

struct Track: Decodable {
   let trackName: String?
   let collectionName: String?
   let artistName: String
   let artworkUrl100: String?
}
