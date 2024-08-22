import SwiftUI
struct LostThresholdView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedThreshold: Int?
    let thresholds = [10, 15, 25, 30, 45, 60]

    var body: some View {
        List(thresholds, id: \.self) { threshold in
            HStack {
                Text("\(threshold) days")
                Spacer()
                if selectedThreshold == threshold {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedThreshold = threshold
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Lost Threshold")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back") // Optional, add if you want text next to the chevron
                    }
                    .foregroundColor(.black) // Set the color to black
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LostThreshold_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LostThresholdView(selectedThreshold: .constant(nil))
        }
    }
}
