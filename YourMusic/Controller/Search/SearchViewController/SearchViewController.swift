//
//  SearchViewController.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
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
   
   private lazy var footerView = FooterView()
   weak var tabBarDelegate: MainTabBarControllerDelagate?
   
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
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      let keyWindow = UIApplication.shared.connectedScenes.filter { scene in
         scene.activationState == .foregroundActive
      }.map { scene in
         scene as? UIWindowScene
      }.compactMap({$0}).first?.windows.filter({ window in
         window.isKeyWindow
      }).first
      let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
      tabBarVC?.trackDetailView.delegate = self
      
   }
   //MARK: - flow funcs
   private func setupSearchBar() {
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.delegate = self
      searchBar(searchController.searchBar, textDidChange: "Elvis")
      
   }
   
   private func setupTableView() {
      table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cells.searchCell)
      
      let nib = UINib(nibName: "TrackCell", bundle: nil)
      table.register(nib, forCellReuseIdentifier: Constants.cells.trackCell)
      table.tableFooterView = footerView
   }
   
   
   
   func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .displayTracks(let searchViewModel):
         self.searchViewModel = searchViewModel
         table.reloadData()
         footerView.hideLoading()
      case .displayFooterView:
         footerView.showLoader()
      }
   }
   
}

//MARK: - TableView delegate, dataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      searchViewModel.cells.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = table.dequeueReusableCell(withIdentifier: Constants.cells.trackCell, for: indexPath) as? TrackCell else {
         return UITableViewCell()
      }
      
      let cellViewModel = searchViewModel.cells[indexPath.row]
      cell.configure(viewModel: cellViewModel)
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cellViewModel = searchViewModel.cells[indexPath.row]
      self.tabBarDelegate?.maximizedTrackDetailView(viewModel: cellViewModel)
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      84
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let label = UILabel()
      label.text = "Plaese enter search term above."
      label.textAlignment = .center
      label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
      return label
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return searchViewModel.cells.count > 0 ? 0 : 250
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

extension SearchViewController: TrackMovingDelegate {
   
   private func getTrack(isForwardTrack:Bool) -> SearchViewModel.Cell? {
      
      guard let indexPath = table.indexPathForSelectedRow else { return nil }
      
      var nextIndexPath: IndexPath!
      
      table.deselectRow(at: indexPath, animated: true)
      
      if isForwardTrack {
         nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
         if nextIndexPath.row == searchViewModel.cells.count {
            nextIndexPath.row = 0
         }
      } else {
         nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
         if nextIndexPath.row == -1 {
            nextIndexPath.row = searchViewModel.cells.count - 1
         }
      }
      
      table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
      let cellViewModel = searchViewModel.cells[nextIndexPath.row]
      return cellViewModel
      
   }
   
   func movePreviousTrack() -> SearchViewModel.Cell? {
      return getTrack(isForwardTrack: false)
   }
   
   func moveNextTrack() -> SearchViewModel.Cell? {
      return getTrack(isForwardTrack: true)
   }
   
   
}
