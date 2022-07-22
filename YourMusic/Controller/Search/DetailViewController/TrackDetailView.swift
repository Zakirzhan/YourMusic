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
   @IBOutlet weak var minimizeButton: UIButton!
   
   @IBOutlet weak var miniTrackView: UIView!
   @IBOutlet weak var miniTrackImageView: UIImageView!
   @IBOutlet weak var miniTrackTitleView: UILabel!
   @IBOutlet weak var miniPlayPauseButton: UIButton!
   @IBOutlet weak var miniNextTrackButton: UIButton!
   
   private let player: AVPlayer = {
      let avPlayer = AVPlayer()
      avPlayer.automaticallyWaitsToMinimizeStalling = false
      return avPlayer
   }()
   
   private let scale: CGFloat = 0.8
   private var volume: Float = 0.5
   private var viewTranslation = CGPoint(x: 0, y: 0)
   
   weak var delegate: TrackMovingDelegate?
   weak var tabBarDelegate: MainTabBarControllerDelagate?
   
   //MARK: - AwakeFromNib
   override func awakeFromNib() {
      super.awakeFromNib()
      setup()
      setupGestures()
   }
   
   //MARK: - flow func
   private func setup() {
      trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
      trackImageView.layer.cornerRadius = 5
      
      player.volume = volume
      
   }
   
   func configure(viewModel: SearchViewModel.Cell) {
      trackTitleLabel.text = viewModel.trackName
      miniTrackTitleView.text = viewModel.trackName
      authorTitleLabel.text = viewModel.artistName
      playPauseButton.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
      
      trackImageView.dropShadow()
      miniTrackImageView.dropShadow(color: UIColor.black.cgColor, opacity: 0.5, radius: 1, offset: CGSize(width: 1 , height: 1))
      
      playTrack(previewUrl: viewModel.previewUrl)
      monitorStartTime()
      observePlayerCurrentTime()
      
      let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
      guard let url = URL(string: string600 ?? "") else { return }
      trackImageView.sd_setImage(with: url)
      miniTrackImageView.sd_setImage(with: url)
      
      
   }
   
   //Gestures
   private func setupGestures() {
      miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
      miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
      minimizeButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(hanldeDismissPan)))
   }
   
   
   
   private func playTrack(previewUrl: String?) {
      guard let url = URL(string: previewUrl ?? "") else { return }
      let playerItem = AVPlayerItem(url: url)
      player.replaceCurrentItem(with: playerItem)
      player.play()
      player.volume = volume
      
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
   
   @objc private func handleTapMaximized() {
      self.tabBarDelegate?.maximizedTrackDetailView(viewModel: nil)
   }
   
   @objc private func handlePan(gesture: UIPanGestureRecognizer) {
      
      switch gesture.state {
      case .changed:
         handlePanChanged(gesture: gesture)
      case .ended:
         handlePanEnded(gesture: gesture)
      @unknown default:
         debugPrint("unknown default")
      }
   }

   @objc private func hanldeDismissPan(gesture: UIPanGestureRecognizer) {
      switch gesture.state {
      case .changed:
         viewTranslation = gesture.translation(in: self)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
         })
      case .ended:
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if self.viewTranslation.y > 200 {
               self.tabBarDelegate?.minimizeTrackDetailController()
            }
         })
         
      @unknown default:
         debugPrint("unknown gesture")
      }
      
   }
   
   private func handlePanChanged(gesture: UIPanGestureRecognizer) {
      let translation = gesture.translation(in: self.superview)
      self.transform = CGAffineTransform(translationX: 0, y: translation.y)
      
      let newAlpha = 1 + translation.y / 200
      self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
      self.trackImageView.alpha = -translation.y / 200
      self.minimizeButton.alpha = -translation.y / 200
      
   }
   
   private func handlePanEnded(gesture: UIPanGestureRecognizer) {
      let translation = gesture.translation(in: self.superview)
      let velocity = gesture.velocity(in: self.superview)
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
         self.transform = .identity
         if translation.y < -200 || velocity.y < -500 {
            self.tabBarDelegate?.maximizedTrackDetailView(viewModel: nil)
         } else {
            self.miniTrackView.alpha = 1
            self.trackImageView.alpha = 0
            self.minimizeButton.alpha = 0
         }
      }
   }
   
   
   @IBAction func dragDownButtonTapped(_ sender: UIButton) {
      self.tabBarDelegate?.minimizeTrackDetailController()
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
      volume = sender.value
      player.volume = volume
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
         sender.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
      } else {
         reduceTrackImageView()
         player.pause()
         sender.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
      }
   }
   
}





