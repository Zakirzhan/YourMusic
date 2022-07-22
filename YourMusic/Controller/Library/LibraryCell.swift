//
//  LibraryCell.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 22.07.2022.
//

import SwiftUI
import URLImage

struct LibraryCell: View {
   var cell: SearchViewModel.Cell
   
    var body: some View {
       HStack(spacing:10) {
          
          URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
             image
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60, alignment: .center)
                .cornerRadius(6)
          }

          VStack(alignment: .leading, spacing:5) {
             Text(cell.trackName ?? "Track Title")
                .font(.title3)
                .fontWeight(.medium)
             Text(cell.artistName)
                .font(.footnote)
                .foregroundColor(.gray)
          }
       }
       .padding(.vertical, 5)
    }
}

struct LibraryCell_Previews: PreviewProvider {
   static let tracks = UserDefaults.standard.savedTracks()
   
    static var previews: some View {
       LibraryCell(cell: tracks[0])
          .previewLayout(.sizeThatFits)
          .padding()
    }
}
