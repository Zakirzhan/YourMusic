//
//  LibraryView.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 22.07.2022.
//

import SwiftUI

struct LibraryView: View {
   
   var tracks = UserDefaults.standard.savedTracks()
   
   var body: some View {
      NavigationView {
         VStack {
            GeometryReader { geometry in
               let buttonWidth = geometry.size.width / 2 - 20
               VStack {
                  HStack {
                     Button() {
                        //
                     } label: {
                        Image(systemName: "play.fill")
                           .foregroundColor(.pink)
                           .frame(width: abs(buttonWidth) , height: 50)
                           .background(Color(UIColor.systemGray6.cgColor))
                           .cornerRadius(10)
                     }// Button
                     .padding(.leading)
                     
                     Button {
                        //
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
                  List(tracks) { track in
                     LibraryCell(cell: track)
                     
                  }
                  .listStyle(.inset)
                  
               } // VStack
            } // geometry  
         } //VStack
         .navigationTitle("Library")
      } //Navigation
      
   }
}

struct LibraryView_Previews: PreviewProvider {
   static var previews: some View {
      LibraryView()
   }
}
