//
//  NetworkService.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
   case serverError
   case decodingError
}

class NetworkService {
   
   func fetchTracks(searchText: String, completion: @escaping(Result<SearchResponse, NetworkError>) -> Void) {
      let url = "https://itunes.apple.com/search?term=\(searchText)"
      let parametrs = ["term":"\(searchText)",
                       "limit":"10",
                       "media":"music"
      ]
      
      AF.request(url, parameters: parametrs).responseData { dataResponse in

         guard let data = dataResponse.data, dataResponse.error == nil else {
            completion(.failure(.serverError))
            return
         }
         
         let decoder = JSONDecoder()
         
         do {
            let object = try decoder.decode(SearchResponse.self, from: data)
            completion(.success(object))
         } catch {
            completion(.failure(.decodingError))
         }
         
      }
   }
}
