//
//  ShiftsPage.swift
//  Project
//
//  Created by Khushi Verma on 05/06/24.
//

import SwiftUI

struct ShiftsPageView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false

    var body: some View {
        Form {
            // Date Section
            Section {
                HStack {
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.headline)
                        .padding(.vertical, 10)
                    Spacer()
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            withAnimation {
                                showDatePicker.toggle()
                            }
                        }
                }
                if showDatePicker {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                }
            }

            // Details Section
            Section(header: Text("Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .textCase(.none) // Ensure text case is not altered
            ) {
                if hasShift(for: selectedDate) {
                    HStack {
                        Image(systemName: "calendar")
                        VStack(alignment: .leading) {
                            Text("Date of shift")
                                .font(.headline)
                            Text(dateFormatter.string(from: selectedDate))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Image(systemName: "clock")
                        VStack(alignment: .leading) {
                            Text("Duration of Shift")
                                .font(.headline)
                            Text("10:00 AM - 8:00 PM")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Image(systemName: "house")
                        VStack(alignment: .leading) {
                            Text("Location")
                                .font(.headline)
                            Text("Reading Hall")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("No Shifts Today")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 10)
                }
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            // Dismiss action here
        }.foregroundColor(.black)) // Change "Done" button color to black
    }

    // DateFormatter for formatting date display
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    // Dummy function to determine if there is a shift on a given date
    private func hasShift(for date: Date) -> Bool {
        // Replace with your actual logic to check if there is a shift on the given date
        // Here, we assume there is no shift if the selected date is today
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: Date()) == false
    }
}

// This is needed for preview purposes only
struct ShiftsPageView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftsPageView()
    }
}
