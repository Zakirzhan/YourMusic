//
//  TrackDetailView.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 19.07.2022.
//

import Foundation
import UIKit
import SDWebImage
import AVKit

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
   
   let player: AVPlayer = {
      let avPlayer = AVPlayer()
      avPlayer.automaticallyWaitsToMinimizeStalling = false
      return avPlayer
   }()
   
   override class func awakeFromNib() {
      super.awakeFromNib()
   }
   
   //MARK: - flow func
   func configure(viewModel: SearchViewModel.Cell) {
      trackTitleLabel.text = viewModel.trackName
      authorTitleLabel.text = viewModel.artistName
      playTrack(previewUrl: viewModel.previewUrl)
      
      let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
      guard let url = URL(string: string600 ?? "") else { return }
      trackImageView.sd_setImage(with: url)
   }
   
   private func playTrack(previewUrl: String?) {
      
      guard let url = URL(string: previewUrl ?? "") else { return }
      let playerItem = AVPlayerItem(url: url)
      player.replaceCurrentItem(with: playerItem)
      player.play()
      player.volume = 0.5
   }
   
   //MARK: - Actions
   @IBAction func dragDownButtonTapped(_ sender: UIButton) {
      self.removeFromSuperview()
   }
   
   @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
      
   }
   
   @IBAction func handleVolumeSlider(_ sender: UISlider) {
      player.volume = sender.value
   }
   
   @IBAction func previousTrack(_ sender: UIButton) {
      
   }
   
   @IBAction func nextTrack(_ sender: UIButton) {
      
   }
   
   @IBAction func playPauseAction(_ sender: UIButton) {
      if player.timeControlStatus == .paused {
         player.play()
         playPauseButton.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
      } else {
         player.pause()
         playPauseButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
      }
   }
   
}



