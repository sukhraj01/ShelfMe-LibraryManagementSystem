

import SwiftUI

struct ProfileRowView: View {
    var image: UIImage?
    var user : LoggedInUser
    
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
                Text("\(user.name)")
                    .font(.headline)
                Text("\(user.email)")
                    .font(.subheadline)
            }
        }
    }
}

//struct ProfileRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileRowView()
//    }
//}
