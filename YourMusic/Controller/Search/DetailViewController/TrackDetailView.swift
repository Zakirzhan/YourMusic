//
//  TrackDetailView.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 19.07.2022.
//

import Foundation
import UIKit

class TrackDetailView: UIView {
   //MARK: - Properties
   
   @IBOutlet weak var trackImageView: UIImageView!
   @IBOutlet weak var currentTimeSlider: UISlider!
   @IBOutlet weak var currentTimeLabel: UILabel!
   @IBOutlet weak var durationLabel: UILabel!
   @IBOutlet weak var trackTitleLabel: UILabel!
   @IBOutlet weak var authorTitleLabel: UILabel!
   @IBOutlet weak var playPauseButton: UIButton!
   @IBOutlet weak var volumeSlider: UISlider!
   
   override class func awakeFromNib() {
      super.awakeFromNib()
   }
   
   //MARK: - Actions
   @IBAction func dragDownButtonTapped(_ sender: UIButton) {
      self.removeFromSuperview()
   }
   
   @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
      
   }
   
   @IBAction func handleVolumeSlider(_ sender: UISlider) {
      
   }
   
   @IBAction func previousTrack(_ sender: UIButton) {
      
   }
   
   @IBAction func nextTrack(_ sender: UIButton) {
      
   }
   
   @IBAction func playPauseAction(_ sender: UIButton) {
      
   }
   
}



