//
//  UserDefaults+extension.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 22.07.2022.
//

import Foundation

extension UserDefaults {
   func savedTracks() -> [SearchViewModel.Cell] {
      let defautls = UserDefaults.standard
      
      guard let savedTrack = defautls.object(forKey: Constants.keys.trackKey) as? Data else { return [] }
      guard let decodedTrack = try?
               NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as?
               [SearchViewModel.Cell] else { return [] }
      
      return decodedTrack
   }
}
