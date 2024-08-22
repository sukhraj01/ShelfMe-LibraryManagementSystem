import SwiftUI

struct LoanPeriodView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedPeriod: Int?
    let periods = [5, 7, 10, 12, 15, 20, 30]
    
    var body: some View {
        List(periods, id: \.self) { period in
            HStack {
                Text("\(period) days")
                Spacer()
                if selectedPeriod == period {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedPeriod = period
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Loan Period")
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

struct LoanPeriodView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoanPeriodView(selectedPeriod: .constant(nil))
        }
    }
}
