//
//  SearchInteractor.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
   func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
   
   var networkService = NetworkService()
   
   var presenter: SearchPresentationLogic?
   var service: SearchService?
   
   func makeRequest(request: Search.Model.Request.RequestType) {
      if service == nil {
         service = SearchService()
      }
      
      switch request {
      case .getTracks(let searchText):
         presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
         networkService.fetchTracks(searchText: searchText) { [weak self] result in
            switch result {
            case .success(let searchResponse):
               self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse))
            case .failure(let error):
               debugPrint(error.localizedDescription)
            }
         }
      }
   }
   
}
