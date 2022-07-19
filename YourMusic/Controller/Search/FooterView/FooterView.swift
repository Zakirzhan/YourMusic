//
//  FooterView.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 19.07.2022.
//

import Foundation
import UIKit

class FooterView: UIView {
   
   private var myLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 14)
      label.textAlignment = .center
      label.textColor = UIColor.systemGray3
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private var loader: UIActivityIndicatorView = {
      let loader = UIActivityIndicatorView()
      loader.translatesAutoresizingMaskIntoConstraints = false
      loader.hidesWhenStopped = true
      return loader
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      layout()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}

extension FooterView {
   
   func layout() {
      addSubview(myLabel)
      addSubview(loader)
      NSLayoutConstraint.activate([
         loader.topAnchor.constraint(equalTo: topAnchor, constant: 8),
         loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
         
         myLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         myLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8)
      ])
   }
   
   func showLoader() {
      loader.startAnimating()
      myLabel.text = "LOADING"
   }
   
   func hideLoading() {
      loader.stopAnimating()
      myLabel.text = ""
   }
}

