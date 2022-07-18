//
//  MainTabBarController.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 18.07.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
   
      setupViews()
      setupTabBar()
   }
   
   //MARK: - Funcs
   private func setupViews() {
      
      let searchVC = SearchViewController()
      let libraryVC = ViewController()

      let tabBarList = [generateViewControlles(rootVC: searchVC, image: UIImage(systemName: "magnifyingglass"), title: "Search"),
                        generateViewControlles(rootVC: libraryVC, image: UIImage(systemName: "music.note.list"), title: "Library")]
      
      viewControllers = tabBarList
   }
   
   private func setupTabBar() {
      tabBar.tintColor = .systemPink
   }
   
   private func generateViewControlles(rootVC: UIViewController, image: UIImage?, title: String) -> UIViewController {
      let navigationVC = UINavigationController(rootViewController:  rootVC)
      navigationVC.tabBarItem.image = image
      navigationVC.tabBarItem.title = title
      rootVC.navigationItem.title = title
      navigationVC.navigationBar.prefersLargeTitles = true
      return navigationVC
   }
}


