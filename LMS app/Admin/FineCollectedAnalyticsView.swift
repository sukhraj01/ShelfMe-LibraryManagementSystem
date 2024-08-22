import SwiftUI

struct FineCollectedAnalyticsView: View {
    @State private var selectedSegment = 0
    @Environment(\.presentationMode) var presentationMode  // Environment variable to control modal presentation

    private var totalFineCollected: Int {
        currentStats.reduce(0) { $0 + $1.issues }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer().frame(height: -20)
                    Picker("", selection: $selectedSegment) {
                        Text("Weekly").tag(0)
                        Text("Monthly").tag(1)
                        Text("Yearly").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Infosys Mysore DC")
                                    .font(.headline)
                                Text("29th June, 2024")
                                    .font(.subheadline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Total Fine Collected")
                                    .font(.headline)
                                Text("$\(totalFineCollected)")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        HStack(alignment: .bottom) {
                            ForEach(currentStats, id: \.day) { stat in
                                VStack {
                                    Rectangle()
                                        .fill(LinearGradient(
                                                           gradient: Gradient(colors: [Color.gray, Color.black]),
                                                           startPoint: .top,
                                                           endPoint: .bottom
                                                       ))
                                        .frame(width: 30, height: self.heightForFine(stat.issues))
                                    Text(stat.shortDay)
                                        .font(.caption)
                                }
                            }
                        }
                        .frame(height: 250)
                        .padding(.horizontal)

                        Text("Statistics")
                            .font(.headline)

                        VStack {
                            HStack {
                                Text("Day")
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                Text("Fine Collected")
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                            }
                            .frame(height: 30)

                            ForEach(currentStats, id: \.day) { stat in
                                HStack {
                                    Text(stat.day)
                                        .frame(maxWidth: .infinity)
                                        .border(Color.black)
                                    Text("$\(stat.issues)")
                                        .frame(maxWidth: .infinity)
                                        .border(Color.black)
                                }
                                .frame(height: 30)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .navigationTitle("Fine Collected Analytics")
            .navigationBarTitle("Issued Books Analytics", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func heightForFine(_ fineCollected: Int) -> CGFloat {
        let maxFineCollected = currentStats.map { $0.issues }.max() ?? 1
        let maxHeight: CGFloat = 200
        return CGFloat(fineCollected) / CGFloat(maxFineCollected) * maxHeight
    }

    private let weeklyStats = [
        DayStat(day: "Sunday", shortDay: "S", issues: 100),
        DayStat(day: "Monday", shortDay: "M", issues: 150),
        DayStat(day: "Tuesday", shortDay: "T", issues: 120),
        DayStat(day: "Wednesday", shortDay: "W", issues: 180),
        DayStat(day: "Thursday", shortDay: "T", issues: 130),
        DayStat(day: "Friday", shortDay: "F", issues: 170),
        DayStat(day: "Saturday", shortDay: "S", issues: 140)
    ]

    private let monthlyStats = [
        DayStat(day: "January", shortDay: "Jan", issues: 1500),
        DayStat(day: "February", shortDay: "Feb", issues: 1800),
        DayStat(day: "March", shortDay: "Mar", issues: 1700),
        DayStat(day: "April", shortDay: "Apr", issues: 1900),
        DayStat(day: "May", shortDay: "May", issues: 1600),
        DayStat(day: "June", shortDay: "Jun", issues: 2000)
    ]

    private let yearlyStats = [
        DayStat(day: "2021", shortDay: "2021", issues: 15000),
        DayStat(day: "2022", shortDay: "2022", issues: 17000),
        DayStat(day: "2023", shortDay: "2023", issues: 18500),
        DayStat(day: "2024", shortDay: "2024", issues: 20000)
    ]

    private var currentStats: [DayStat] {
        switch selectedSegment {
        case 0:
            return weeklyStats
        case 1:
            return monthlyStats
        case 2:
            return yearlyStats
        default:
            return []
        }
    }
}


#Preview {
    FineCollectedAnalyticsView()
}
