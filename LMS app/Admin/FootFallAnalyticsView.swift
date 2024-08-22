import SwiftUI

struct FootFallAnalyticsView: View {
    @State private var selectedSegment = 0
    @Environment(\.presentationMode) var presentationMode

    private var totalFootFall: Int {
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
                                Text("Total Foot Fall")
                                    .font(.headline)
                                Text("\(totalFootFall)")
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
                                        .frame(width: 30, height: self.heightForFootFall(stat.issues))
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
                                Text("Foot Fall")
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
                                    Text("\(stat.issues)")
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
            .navigationTitle("Foot Fall")
            .navigationBarTitle("Issued Books Analytics", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func heightForFootFall(_ footFall: Int) -> CGFloat {
        let maxFootFall = currentStats.map { $0.issues }.max() ?? 1
        let maxHeight: CGFloat = 200
        return CGFloat(footFall) / CGFloat(maxFootFall) * maxHeight
    }

    private let weeklyStats = [
        DayStat(day: "Sunday", shortDay: "S", issues: 392),
        DayStat(day: "Monday", shortDay: "M", issues: 233),
        DayStat(day: "Tuesday", shortDay: "T", issues: 245),
        DayStat(day: "Wednesday", shortDay: "W", issues: 392),
        DayStat(day: "Thursday", shortDay: "T", issues: 233),
        DayStat(day: "Friday", shortDay: "F", issues: 245),
        DayStat(day: "Saturday", shortDay: "S", issues: 444)
    ]

    private let monthlyStats = [
        DayStat(day: "January", shortDay: "Jan", issues: 2000),
        DayStat(day: "February", shortDay: "Feb", issues: 1800),
        DayStat(day: "March", shortDay: "Mar", issues: 2100),
        DayStat(day: "April", shortDay: "Apr", issues: 1900),
        DayStat(day: "May", shortDay: "May", issues: 2200),
        DayStat(day: "June", shortDay: "Jun", issues: 2400)
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


struct FootFallAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        FootFallAnalyticsView()
    }
}
