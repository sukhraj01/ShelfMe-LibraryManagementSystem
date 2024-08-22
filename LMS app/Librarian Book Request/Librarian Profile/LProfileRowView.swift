//
//  LProfileRowView.swift
//  LibraryProfile
//
//  Created by PRIYANSHU MISHRA on 13/06/24.
//

import SwiftUI

struct LProfileRowView: View {
    var image: UIImage?
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text("Khushi Verma")
                    .font(.headline)
                Text("khushiverma@gmail.com")
                    .font(.subheadline)
            }
        }
    }
}

struct LProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        LProfileRowView()
    }
}
