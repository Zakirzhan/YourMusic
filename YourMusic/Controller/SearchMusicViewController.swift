//
//  SearchViewController.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//

import Foundation
import UIKit
import Alamofire

class SearchMusicViewController: UITableViewController {
   
   //MARK: - Properties
   private let searchController = UISearchController(searchResultsController: nil)
   private var timer = Timer()
   
   private var networkService = NetworkService()
   private var tracks = [Track]()
   
   //MARK: - Lyfecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      setup()
      setupSearchBar()
      
   }
   
   //MARK: - FLow func
   private func setup() {
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cells.searchCell)
   }
   
   private func setupSearchBar() {
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
      searchController.searchBar.delegate = self
   }
   
}

//MARK: - setupCell
extension SearchMusicViewController {
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      tracks.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.searchCell, for: indexPath)
      let track = tracks[indexPath.row]
      cell.textLabel?.text = "\(track.trackName ?? "noName track")\n\(track.artistName)"
      cell.textLabel?.numberOfLines = 2
      cell.imageView?.image = UIImage(systemName: "circle.fill")
      return cell
   }
}

//MARK: - Search delegate
extension SearchMusicViewController:UISearchBarDelegate {
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
      timer.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
         
         self.networkService.fetchTracks(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
               switch result {
               case .success(let music):
                  self?.tracks = music.results
                  self?.tableView.reloadData()
               case .failure(let error):
                  debugPrint(error.localizedDescription)
               }
            }
         }
         
      })
   }
}
