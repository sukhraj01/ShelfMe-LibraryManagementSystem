import SwiftUI

struct LibrarianShiftsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .padding(.bottom)

                        VStack(alignment: .leading) {
                            Text("Khushi Verma")
                                .font(.headline)
                            Text("khushiverma@gmail.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom)
                        Spacer()
                    }
                    .padding(.top)
                }
                .frame(width: 259, height: 70)

                Section {
                    NavigationLink(destination: ShiftsPageView()) {
                        Text("Shifts")
                    }
                    NavigationLink(destination: NotificationsView()) {
                        Text("Notifications")
                    }
                    NavigationLink(destination: StoreView()) {
                        Text("Store")
                    }
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.black))
        }
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("Notifications View")
            .navigationTitle("Notifications")
    }
}

struct StoreView: View {
    var body: some View {
        Text("Store View")
            .navigationTitle("Store")
    }
}

// This is needed for preview purposes only
struct LibrarianShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        LibrarianShiftsView()
    }
}
