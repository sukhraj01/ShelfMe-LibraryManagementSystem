import SwiftUI

struct LendingPolicyView: View {
    @State private var issueLimit: Int = 0
    @State private var numberOfRenewals: Int = 0
    @State private var finePerDay: String = ""
    @State private var selectedLoanPeriod: Int? = nil
    @State private var selectedLostThreshold: Int? = nil
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Issue Limit: \(issueLimit)")
                        Spacer()
                        Stepper("", value: $issueLimit, in: 0...100)
                            .labelsHidden()
                    }
                } footer: {
                    Text("The number of days for which the book would be landed.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    NavigationLink(destination: LoanPeriodView(selectedPeriod: $selectedLoanPeriod)) {
                        HStack {
                            Text("Loan Period")
                            Spacer()
                            if let selectedPeriod = selectedLoanPeriod {
                                Text("\(selectedPeriod) days")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } footer: {
                    Text("The length of time a borrower can keep an item.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    HStack {
                        Text("Fine/day")
                        Spacer()
                        Text("₹")
                        TextField("Enter amount", text: $finePerDay)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                } footer: {
                    Text("The daily late fee charged to members for each day a book is overdue after its return deadline.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    HStack {
                        Text("No. of Renewals: \(numberOfRenewals)")
                        Spacer()
                        Stepper("", value: $numberOfRenewals, in: 0...10)
                            .labelsHidden()
                    }
                } footer: {
                    Text("Number of times the book could be renewed.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    NavigationLink(destination: LostThresholdView(selectedThreshold: $selectedLostThreshold)) {
                        HStack {
                            Text("Lost Threshold")
                            Spacer()
                            if let selectedThreshold = selectedLostThreshold {
                                Text("\(selectedThreshold) days")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } footer: {
                    Text("Number of days after the due date where a book is considered lost and the borrower is charged the full replacement cost.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Lending Policy", displayMode: .large)
        }
    }
}

struct LendingPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        LendingPolicyView()
    }
}
