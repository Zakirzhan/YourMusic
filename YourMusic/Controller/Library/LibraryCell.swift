//
//  LibraryCell.swift
//  YourMusic
//
//  Created by Kirill Sytkov on 22.07.2022.
//

import SwiftUI

struct LibraryCell: View {
    var body: some View {
       HStack(spacing:10) {
          Image(systemName: "play.fill")
             .resizable()
             .scaledToFit()
             .frame(width: 50, height: 50, alignment: .center)
          VStack(spacing:5) {
             Text("Track name")
             Text("artist Name")
          }
       }
    }
}

struct LibraryCell_Previews: PreviewProvider {
    static var previews: some View {
        LibraryCell()
          .previewLayout(.sizeThatFits)
          .padding()
    }
}
