//
//  SearchViewController.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
   func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
   
   var interactor: SearchBusinessLogic?
   var router: (NSObjectProtocol & SearchRoutingLogic)?
   
   //MARK: - Properties
   @IBOutlet weak var table: UITableView!
   
   private let searchController = UISearchController(searchResultsController: nil)
   private var searchViewModel = SearchViewModel(cells: [])
   private var timer: Timer?
   
   // MARK: Setup
   
   private func setup() {
      let viewController        = self
      let interactor            = SearchInteractor()
      let presenter             = SearchPresenter()
      let router                = SearchRouter()
      viewController.interactor = interactor
      viewController.router     = router
      interactor.presenter      = presenter
      presenter.viewController  = viewController
      router.viewController     = viewController
   }
   
   // MARK: Routing
   
   
   
   // MARK: View lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setup()
      
      setupSearchBar()
      setupTableView()
   }
   
   //MARK: - flow funcs
   private func setupSearchBar() {
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.delegate = self
   }
   
   private func setupTableView() {
      table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cells.searchCell)
   }
   
   
   
   func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      switch viewModel {
         
      case .some:
         print("viewControlle .some")
      case .displayTracks(let searchViewModel):
         self.searchViewModel = searchViewModel
         table.reloadData()
         
      }
   }
   
}

//MARK: - TableView delegate, dataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      searchViewModel.cells.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = table.dequeueReusableCell(withIdentifier: Constants.cells.searchCell, for: indexPath)
      let cellViewModel = searchViewModel.cells[indexPath.row]
      cell.textLabel?.text = "\(cellViewModel.trackName ?? "NoName")\n\(cellViewModel.artistName)"
      cell.textLabel?.numberOfLines = 2
      cell.imageView?.image = UIImage(systemName: "circle.fill")
      return cell
   }
   
   
}

//MARK: - SearchBar delegate
extension SearchViewController:UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      timer?.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
         self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchText))         
      })
   }
}
