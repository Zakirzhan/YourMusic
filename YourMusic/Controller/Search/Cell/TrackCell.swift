//
//  TrackCell.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 19.07.2022.
//

import Foundation
import UIKit

protocol TrackCellViewModel {
   var iconUrlString: String? { get }
   var trackName: String? { get }
   var artistName: String { get }
   var collectionName: String? { get }
}

class TrackCell: UITableViewCell {
   
   //MARK: - IBOutlets
   @IBOutlet weak var trackImageVew: UIImageView!
   @IBOutlet weak var trackNameLabel: UILabel!
   @IBOutlet weak var artistNameLabel: UILabel!
   @IBOutlet weak var collectionNameLabel: UILabel!
   
   override class func awakeFromNib() {
      super.awakeFromNib()
   }
   
   //MARK: - flow func
   func configure(viewModel: TrackCellViewModel) {
      trackNameLabel.text = viewModel.trackName
      artistNameLabel.text = viewModel.artistName
      collectionNameLabel.text = viewModel.collectionName
   }
   
}
