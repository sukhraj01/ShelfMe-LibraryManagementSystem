//  Event View

//
//  EventView.swift
//  LMS app
//
//  Created by Khushi Verma on 11/06/24.
//

import SwiftUI

struct EventView: View {
    var event: Event

    // Date Formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        ScrollView {
            ZStack {
                Color.gray.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Event Image
                    VStack {
                        AsyncImage(url: URL(string: event.imageName)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 250, height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 200)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.leading,100)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 200)
                                    .clipped()
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                                    .padding(.leading,100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    // Event Details
                    VStack(alignment: .leading, spacing: 5) {
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, -100)
                             
                        
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(dateFormatter.string(from: event.startDate)) - \(dateFormatter.string(from: event.endDate))")
                        }
                        .padding(.top, 10)
                        
                        HStack {
                            Image(systemName: "clock")
                            Text(event.time)
                        }
                        .padding(.top, 4)
                        
                        HStack {
                            Image(systemName: "textformat.size")
                            Text(event.language)
                        }
                        .padding(.top, 4)
                        
                        HStack {
                            Image(systemName: "film")
                            Text(event.genre)
                        }
                        .padding(.top, 4)
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, -15)
                    .padding(.leading, 23.5)
                    .padding(.trailing, 23.5)
                    
                    // About The Event VStack
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About The Event")
                            .font(.headline)
                            .bold()
                        
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.leading, 23.5)
                    .padding(.trailing, 23.5)
                    .padding(.bottom, 140)
                }
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView(event: sampleEvents.first!)
//    }
//}
