//
//  TrackCell.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 19.07.2022.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
   var iconUrlString: String? { get }
   var trackName: String? { get }
   var artistName: String { get }
   var collectionName: String? { get }
}

class TrackCell: UITableViewCell {
   
   //MARK: - IBOutlets
   @IBOutlet weak var trackImageView: UIImageView!
   @IBOutlet weak var trackNameLabel: UILabel!
   @IBOutlet weak var artistNameLabel: UILabel!
   @IBOutlet weak var collectionNameLabel: UILabel!
   @IBOutlet weak var addTrackButton: UIButton!
   
   private var cell: SearchViewModel.Cell?
   
   override class func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override func prepareForReuse() {
      super.prepareForReuse()
      trackImageView.image = nil
   }
   
   //MARK: - flow func
   func configure(viewModel: SearchViewModel.Cell) {

      self.cell = viewModel
      let listOfTracks = UserDefaults.standard.savedTracks()
      
      let hasFavorite = listOfTracks.firstIndex(where: {
         $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
      }) != nil
      
      if hasFavorite {
         addTrackButton.isHidden = true
      } else {
         addTrackButton.isHidden = false
      }
      
      trackNameLabel.text = viewModel.trackName
      artistNameLabel.text = viewModel.artistName
      collectionNameLabel.text = viewModel.collectionName
      
      guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
      trackImageView.sd_setImage(with: url)
      trackImageView.layer.cornerRadius = 6
   }
   
   //MARK: - Actions
   @IBAction func addTrackAction(_ sender: UIButton) {
      guard let cell = cell else { return }
      var listOfTracks = UserDefaults.standard.savedTracks()
      
      addTrackButton.isHidden = true
      listOfTracks.append(cell)
      
      if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
         UserDefaults.standard.set(savedData, forKey: Constants.keys.trackKey)
         
      }

   }
}
