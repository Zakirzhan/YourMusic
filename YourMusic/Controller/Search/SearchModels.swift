//
//  SearchModels.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
   enum Model {
      struct Request {
         enum RequestType {
            case some
            case getTracks(_ searchText: String)
         }
      }
      struct Response {
         enum ResponseType {
            case some
            case presentTracks(_ searchResponse: SearchResponse?)
         }
      }
      struct ViewModel {
         enum ViewModelData {
            case some
            case displayTracks(_ searchViewModel: SearchViewModel)
         }
      }
   }
   
}

struct SearchViewModel {
   
   struct Cell: TrackCellViewModel {
      var iconUrlString: String?
      var trackName: String?
      var collectionName: String?
      var artistName: String
      var previewUrl: String?
   }
   
   let cells: [Cell]
}
