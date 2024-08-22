//import SwiftUI
//
//struct ShiftDetailsView: View {
//    @Binding var shift: Shift
//    @State private var showAlert = false
//
//    var body: some View {
//        VStack {
//            Form {
//                Section(header: Text("Details")) {
//                    DatePicker("Date", selection: $shift.date, displayedComponents: .date)
//                    DatePicker("Start Time", selection: $shift.startTime, displayedComponents: .hourAndMinute)
//                    DatePicker("Finish Time", selection: $shift.finishTime, displayedComponents: .hourAndMinute)
//                    HStack {
//                        Text("Total Time")
//                        Spacer()
//                        Text(calculateTotalTime())
//                            .foregroundColor(.gray)
//                    }
//                }
//
//                Section(header: Text("Location")) {
//                    TextField("Location", text: $shift.location)
//                }
//
//                Section(header: Text("Days")) {
//                    TextField("Days", text: $shift.days)
//                }
//            }
//
//            // Delete Shift Button
//            Button(action: {
//                showAlert = true
//            }) {
//                Text("Delete Shift")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                    .padding(.horizontal, 20)
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Confirm Deletion"),
//                      message: Text("Are you sure you want to delete this shift?"),
//                      primaryButton: .destructive(Text("Delete")) {
//                          // Handle shift deletion
//                          // You might want to add code to update the state or notify a parent view
//                      },
//                      secondaryButton: .cancel())
//            }
//            .padding(.bottom, 20)
//        }
//        .navigationBarTitle("Shift Details", displayMode: .inline)
//    }
//
//    private func calculateTotalTime() -> String {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute], from: shift.startTime, to: shift.finishTime)
//        let hours = components.hour ?? 0
//        let minutes = components.minute ?? 0
//        return String(format: "%d hr %d mins", hours, minutes)
//    }
//}
//
//struct ShiftDetailsView_Previews: PreviewProvider {
//    @State static var shift = Shift(date: Date(), startTime: Date(), finishTime: Date(), location: "Reading Hall", days: "Monday to Friday")
//
//    static var previews: some View {
//        ShiftDetailsView(shift: $shift)
//    }
//}
import SwiftUI

struct ShiftDetailsView: View {
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var finishTime = Date()
    @State private var location = "Reading Hall"
    @State private var selectedDays = Set<String>()

    let locations = ["Reading Hall", "Study Hall", "Another Hall"]

    var totalTime: String {
        let interval = finishTime.timeIntervalSince(startTime)
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours) hr \(minutes) mins"
    }

    var body: some View {
        Form {
            Section(header: Text("Details").font(.title2).foregroundColor(.black).bold()) {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                
                DatePicker("Finish Time", selection: $finishTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                
                HStack {
                    Text("Total Time")
                        .bold()
                    Spacer()
                    Text(totalTime)
                        .foregroundColor(.gray)
                }
            }

            Section(header: Text("Location").font(.title2).foregroundColor(.black).bold()) {
                Picker("Location", selection: $location) {
                    ForEach(locations, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Section(header: Text("Days").font(.title2).foregroundColor(.black).bold()) {
                NavigationLink(destination: DaysView(selectedDays: $selectedDays)) {
                    HStack {
                        Text("Days")
                            .bold()
                        Spacer()
                        Text(selectedDays.isEmpty ? "Select Days" : selectedDays.joined(separator: ", "))
                            .foregroundColor(.gray)
                    }
                }
            }

            Button(action: {
                // Action to delete shift
            }) {
                Text("Delete Shift")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 3)  // Adjust vertical padding to make the button height smaller
            }
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
        .navigationBarTitle("Shift Details", displayMode: .inline)
    }
}

struct ShiftDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftDetailsView()
    }
}
