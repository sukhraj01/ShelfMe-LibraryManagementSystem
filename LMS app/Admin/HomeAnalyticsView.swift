import SwiftUI

// Main view showing the Home Analytics
struct HomeAnalyticsView: View {
    @State private var showIssueBookAnalytics = false  // State to show modal

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Large Title and Subtitle
                LargeTitleWithSubtitle()
                    .padding(.bottom)

                // Analytics Grid
                VStack(alignment: .leading) {
                    Text("Analytics")
                        .font(.headline)
                        .padding(.leading)
                    GridView(showIssueBookAnalytics: $showIssueBookAnalytics)  // Pass state to GridView
                }
                .padding(.top)

                // Monthly Statistics
                VStack(alignment: .leading) {
                    Text("Monthly Statistics")
                        .font(.headline)
                        .padding(.leading)
                    StatisticsView()
                }
                .padding(.top)

                Spacer()
            }
            .padding()
                        .background(Color(UIColor.systemGray6)) // Set background color
                        .navigationBarItems(trailing: NavigationLink(destination: AdAccountView()) {
                            Image(systemName: "person.circle")
                        })
                        .navigationBarHidden(false)
                        .sheet(isPresented: $showIssueBookAnalytics) {  // Present IssueBookAnalyticsView
                            IssueBookAnalyticsView()
                        }
        }
    }
}

struct GridView: View {
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var showIssueBookAnalytics: Bool
    @State private var showFineCollectedAnalytics = false
    @State private var showNewUsersAnalytics = false
    @State private var showFootFallAnalytics = false

    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 20) {
            AnalyticsButton(imageName: "book", title: "Issued Book") {
                showIssueBookAnalytics = true
            }
            AnalyticsButton(imageName: "dollarsign.circle", title: "Fine Collected") {
                showFineCollectedAnalytics = true
            }
            AnalyticsButton(imageName: "person.2", title: "New Users") {
                showNewUsersAnalytics = true
            }
            AnalyticsButton(imageName: "figure.walk", title: "Foot Fall") {
                showFootFallAnalytics = true
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showIssueBookAnalytics) {
            IssueBookAnalyticsView()
        }
        .sheet(isPresented: $showFineCollectedAnalytics) {
            FineCollectedAnalyticsView()
        }
        .sheet(isPresented: $showNewUsersAnalytics) {
            NewUsersAnalyticsView()
        }
        .sheet(isPresented: $showFootFallAnalytics) {
            FootFallAnalyticsView()
        }
    }
}

//
// Custom button used in GridView
struct AnalyticsButton: View {
    let imageName: String
    let title: String
    var action: () -> Void = {}  // Default empty closure

    var body: some View {
        Button(action: action) {  // Use the closure for button action
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
                Text(title)
                    .font(.subheadline)
                    .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// Dummy LargeTitleWithSubtitle component for the example
struct LargeTitleWithSubtitle: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Home")
                .font(.largeTitle)
                .bold()
            Text("Infosys Library Administrator")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// Dummy StatisticsView component for the example
struct StatisticsView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Label("New Users", systemImage: "person.3")
                Spacer()
                Text("200")
                Image(systemName: "arrow.up")
                    .foregroundColor(.green)
            }
            .padding(.vertical, 4)
            
            HStack {
                Label("Total Librarians", systemImage: "person.text.rectangle")
                Spacer()
                Text("15")
            }
            .padding(.vertical, 4)
            
            HStack {
                Label("Total Books", systemImage: "books.vertical")
                Spacer()
                Text("16,420")
                Image(systemName: "arrow.up")
                    .foregroundColor(.green)
            }
            .padding(.vertical, 4)
            
            HStack {
                Label("CashFlow", systemImage: "dollarsign.circle")
                Spacer()
                Text("$123")
            }
            .padding(.vertical, 4)
        }
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
    }
}

// Dummy IssueBookAnalyticsView for the modal example
#Preview {
    HomeAnalyticsView()
}
