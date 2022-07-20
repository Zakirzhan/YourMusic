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

protocol TrackMovingDelegate: AnyObject {
   func movePreviousTrack() -> SearchViewModel.Cell?
   func moveNextTrack() -> SearchViewModel.Cell?
}

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
   let scale: CGFloat = 0.8
   
   weak var delegate: TrackMovingDelegate?
   
   
   //MARK: - AwakeFromNib
   override func awakeFromNib() {
      super.awakeFromNib()
      setup()
      
   }
   
   //MARK: - flow func
   private func setup() {
      trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
      trackImageView.layer.cornerRadius = 5
   }
   
   func configure(viewModel: SearchViewModel.Cell) {
      trackTitleLabel.text = viewModel.trackName
      authorTitleLabel.text = viewModel.artistName
      playTrack(previewUrl: viewModel.previewUrl)
      monitorStartTime()
      observePlayerCurrentTime()
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
   
   // Time setup
   private func monitorStartTime() {
      
      let time = CMTimeMake(value: 1, timescale: 3)
      let timer = [NSValue(time: time)]
      
      player.addBoundaryTimeObserver(forTimes: timer, queue: .main) { [weak self] in
         self?.enlargeTrackImageView()
      }
      
   }
   
   private func observePlayerCurrentTime() {
      let interval = CMTimeMake(value: 1, timescale: 2)
      player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
         
         self?.currentTimeLabel.text = time.toDisplayString()
         
         let durationTime = self?.player.currentItem?.duration
         let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
         
         self?.durationLabel.text = "-\(currentDurationText)"
         self?.updateCurrentTimeSlider()
      }
   }
   
   private func updateCurrentTimeSlider() {
      let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
      let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
      let percentage = currentTimeSeconds / durationSeconds
      self.currentTimeSlider.value = Float(percentage)
   }
   
   
   // Animations
   private func enlargeTrackImageView() {
      UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,options: .curveEaseInOut) {
         self.trackImageView.transform = .identity
      }
   }
   
   private func reduceTrackImageView() {
      UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,options: .curveEaseInOut) {
         self.trackImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
      }
   }
   
   //MARK: - Actions
   @IBAction func dragDownButtonTapped(_ sender: UIButton) {
      self.removeFromSuperview()
   }
   
   @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
      let percentage = currentTimeSlider.value
      guard let duration = player.currentItem?.duration else { return }
      let durationInSeconds = CMTimeGetSeconds(duration)
      let seekTimeInSeconds = Float64(percentage) * durationInSeconds
      let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
      player.seek(to: seekTime)
   }
   
   @IBAction func handleVolumeSlider(_ sender: UISlider) {
      player.volume = sender.value
   }
   
   @IBAction func previousTrack(_ sender: UIButton) {
      guard let cellViewModel = delegate?.movePreviousTrack() else { return }
      self.configure(viewModel: cellViewModel)
   }
   
   @IBAction func nextTrack(_ sender: UIButton) {
      guard let cellViewModel = delegate?.moveNextTrack() else { return }
      self.configure(viewModel: cellViewModel)
   }
   
   @IBAction func playPauseAction(_ sender: UIButton) {
      if player.timeControlStatus == .paused {
         enlargeTrackImageView()
         player.play()
         playPauseButton.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
      } else {
         reduceTrackImageView()
         player.pause()
         playPauseButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
      }
   }
   
}





