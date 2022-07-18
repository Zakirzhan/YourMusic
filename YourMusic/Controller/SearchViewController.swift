//
//  SearchViewController.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//

import Foundation
import UIKit
import Alamofire

class SearchViewController: UITableViewController {
   
   //MARK: - Properties
   let searchController = UISearchController(searchResultsController: nil)
   
   let tracks = [TrackModel(trackName: "first track", artistName: "Kirill"), TrackModel(trackName: "Second track", artistName: "Natali")]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setup()
      setupSearchBar()
      
   }
   
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
extension SearchViewController {
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      tracks.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.searchCell, for: indexPath)
      let track = tracks[indexPath.row]
      cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
      cell.textLabel?.numberOfLines = 2
      cell.imageView?.image = UIImage(systemName: "circle.fill")
      return cell
   }
}

//MARK: - Search delegate
extension SearchViewController:UISearchBarDelegate {
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      let url = "https://itunes.apple.com/search?term=\(searchText)"
      
      AF.request(url).responseData { data in
         if let error = data.error {
            debugPrint("Eror received requesting data: \(error.localizedDescription)")
         }
         
         guard let data = data.data else { return }
         let someString = String(data:data, encoding: .utf8)
         print(someString)
      }
   }
}
