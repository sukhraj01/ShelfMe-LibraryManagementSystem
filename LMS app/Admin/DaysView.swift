import SwiftUI

struct DaysView: View {
    @Binding var selectedDays: Set<String>

    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        List(daysOfWeek, id: \.self) { day in
            HStack {
                Text(day)
                Spacer()
                if selectedDays.contains(day) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                } else {
                    Button(action: {
                        // Action for help button
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if selectedDays.contains(day) {
                    selectedDays.remove(day)
                } else {
                    selectedDays.insert(day)
                }
            }
        }
        .navigationBarTitle("Days", displayMode: .inline)
    }
}

struct DaysView_Previews: PreviewProvider {
    static var previews: some View {
        DaysView(selectedDays: .constant(Set<String>()))
    }
}
