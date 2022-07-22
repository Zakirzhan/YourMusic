//
//  MainTabBarController.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//

import Foundation
import UIKit

protocol MainTabBarControllerDelagate: AnyObject {
   func minimizeTrackDetailController()
   func maximizedTrackDetailView(viewModel:SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
   
   //MARK: - Properties
   private var minimizedTopAnchorConstraint: NSLayoutConstraint!
   private var maximizedTopAnchorConstraint: NSLayoutConstraint!
   private var bottomAnchorConstraint: NSLayoutConstraint!
   
   let searchVCStoryboard: SearchViewController = SearchViewController.loadFromStoryboard()
   let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
   
   //MARK: - Lyfecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupViews()
      setupTabBar()
      setupTrackDetailView()
      searchVCStoryboard.tabBarDelegate = self
   }
   
   //MARK: - Funcs
   private func setupTabBar() {
      tabBar.tintColor = .systemPink

   }
   
   private func setupViews() {
      
      let libraryVC = ViewController()
      let tabBarList = [generateViewControlles(rootVC: searchVCStoryboard, image: UIImage(systemName: "magnifyingglass"), title: "Search"),
                        generateViewControlles(rootVC: libraryVC, image: UIImage(systemName: "music.note.list"), title: "Library")]
      
      viewControllers = tabBarList
   }
   
   private func generateViewControlles(rootVC: UIViewController, image: UIImage?, title: String) -> UIViewController {
      let navigationVC = UINavigationController(rootViewController:  rootVC)
      navigationVC.tabBarItem.image = image
      navigationVC.tabBarItem.title = title
      rootVC.navigationItem.title = title
      navigationVC.navigationBar.prefersLargeTitles = true
      return navigationVC
   }
   
   private func setupTrackDetailView() {

      trackDetailView.tabBarDelegate = self
      trackDetailView.delegate = searchVCStoryboard
      
      view.insertSubview(trackDetailView, belowSubview: tabBar)
      
      trackDetailView.translatesAutoresizingMaskIntoConstraints = false
      
      maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
      minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
      bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
      
      NSLayoutConstraint.activate([
         bottomAnchorConstraint,
         maximizedTopAnchorConstraint,
         trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      ])
   }
}

//MARK: - MainTabBar delegate
extension MainTabBarController: MainTabBarControllerDelagate {
   func maximizedTrackDetailView(viewModel: SearchViewModel.Cell?) {
      minimizedTopAnchorConstraint.isActive = false
      maximizedTopAnchorConstraint.isActive = true
      maximizedTopAnchorConstraint.constant = 0
      bottomAnchorConstraint.constant = 0
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseOut) {
         self.trackDetailView.miniTrackView.alpha = 0
         self.trackDetailView.minimizeButton.alpha = 1
         self.trackDetailView.trackImageView.alpha = 1
         self.view.layoutIfNeeded()
         self.tabBar.isHidden = true
      }
      
      guard let viewModel = viewModel else { return }
      self.trackDetailView.configure(viewModel: viewModel)
   }
      
   func minimizeTrackDetailController() {
      maximizedTopAnchorConstraint.isActive = false
      bottomAnchorConstraint.constant = view.frame.height
      minimizedTopAnchorConstraint.isActive = true

      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseOut) {
         self.trackDetailView.miniTrackView.alpha = 1
         self.trackDetailView.minimizeButton.alpha = 0
         self.trackDetailView.trackImageView.alpha = 0
         self.trackDetailView.miniPlayPauseButton.setImage(self.trackDetailView.playPauseButton.imageView?.image, for: .normal)
         self.view.layoutIfNeeded()
         self.tabBar.isHidden = false
      }
   }
     
}

