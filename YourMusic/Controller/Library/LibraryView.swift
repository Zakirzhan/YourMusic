//
//  LibraryView.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 22.07.2022.
//

import SwiftUI
import AVKit

struct LibraryView: View {
   //MARK: - Propeties
   @State var tracks = UserDefaults.standard.savedTracks()
   @State private var showingAlert = false
   @State private var track: SearchViewModel.Cell?
   
   var tabBarDelegate: MainTabBarControllerDelagate?
   
   //MARK: - Body
   var body: some View {
      NavigationView {
         VStack {
            GeometryReader { geometry in
               let buttonWidth = geometry.size.width / 2 - 20
               VStack {
                  HStack {
                     Button() {
                        self.track = self.tracks[0]
                        self.tabBarDelegate?.maximizedTrackDetailView(viewModel: track)
                     } label: {
                        Image(systemName: "play.fill")
                           .foregroundColor(.pink)
                           .frame(width: abs(buttonWidth) , height: 50)
                           .background(Color(UIColor.systemGray6.cgColor))
                           .cornerRadius(10)
                     }// Button
                     .padding(.leading)
                     
                     Button {
                        self.tracks = UserDefaults.standard.savedTracks()
                     } label: {
                        Image(systemName: "arrow.2.circlepath")
                           .foregroundColor(.pink)
                           .frame(width: abs(buttonWidth), height: 50)
                           .background(Color(UIColor.systemGray6.cgColor))
                           .cornerRadius(10)
                     } //Button
                     .padding(.trailing)
                     
                  }//HStack
                  Divider()
                  List{
                     ForEach(tracks) { track in
                        LibraryCell(cell: track)
                           .onTapGesture {
                              self.track = track
                              self.tabBarDelegate?.maximizedTrackDetailView(viewModel: self.track)
                              
                              let keyWindow = UIApplication.shared.connectedScenes.filter { scene in
                                 scene.activationState == .foregroundActive
                              }.map { scene in
                                 scene as? UIWindowScene
                              }.compactMap({$0}).first?.windows.filter({ window in
                                 window.isKeyWindow
                              }).first
                              let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                              tabBarVC?.trackDetailView.delegate = self
                           }
                           .onLongPressGesture(minimumDuration: 0.3, maximumDistance: 0.8) {
                              self.track = track
                              self.showingAlert = true
                           }
                        
                     }
                     .onDelete(perform: delete)
                  }
                  .listStyle(.inset)
                  .actionSheet(isPresented: $showingAlert) {
                     ActionSheet(title: Text("Are you sure you want to delete this track?"), buttons: [.cancel(), .destructive(Text("Delete"), action: {
                        self.delete(track: self.track)
                     })])
                     
                  }
                  
               } // VStack
            } // geometry  
         } //VStack
         .navigationTitle("Library")
      } //Navigation
      .navigationViewStyle(.stack)
      .onAppear {
         self.tracks = UserDefaults.standard.savedTracks()
      }
   } //Body
   
   
   private func delete(at offsets: IndexSet) {
      self.tracks.remove(atOffsets: offsets)
      if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
         UserDefaults.standard.set(savedData, forKey: Constants.keys.trackKey)
      }
   }
   
   private func delete(track: SearchViewModel.Cell?) {
      guard let track = track else { return }
      guard let index = tracks.firstIndex(of: track) else { return }
      
      self.tracks.remove(at: index)
      if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
         UserDefaults.standard.set(savedData, forKey: Constants.keys.trackKey)
      }
   }
   
   
}

//MARK: - Preview
struct LibraryView_Previews: PreviewProvider {
   static var previews: some View {
      LibraryView()
   }
}

extension LibraryView: TrackMovingDelegate {
   
   func movePreviousTrack() -> SearchViewModel.Cell? {
      guard let track = track else { return nil }
      guard let index = tracks.firstIndex(of: track) else { return nil }
      
      var nextTrack: SearchViewModel.Cell
      if index - 1 < 0 {
         nextTrack = tracks[tracks.count - 1]
      } else {
         nextTrack = tracks[index - 1]
      }
      self.track = nextTrack
      return nextTrack
      
   }
   
   func moveNextTrack() -> SearchViewModel.Cell? {
      guard let track = track else { return nil }
      guard let index = tracks.firstIndex(of: track) else { return nil }
      
      var nextTrack: SearchViewModel.Cell
      if index + 1 == tracks.count {
         nextTrack = tracks[0]
      } else {
         nextTrack = tracks[index + 1]
      }
      self.track = nextTrack
      return nextTrack
   }
   
   
}
