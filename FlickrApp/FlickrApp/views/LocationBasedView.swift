//
//  LocationBasedView.swift
//  FlickrApp
//
//  Created by Soha Ahmed on 21/12/2023.
//

import SwiftUI
import CoreLocation

struct LocationBasedView: View {
    
    @StateObject var locationProvider = LocationProvider()
    @EnvironmentObject var modelView : ModelView
    
    var body: some View {
        VStack{
            if !locationProvider.authoried {
                Text("please enable location access")
            }
            
            NavigationStack {
                ImageListView()
                    .edgesIgnoringSafeArea(.horizontal)
                    .listStyle(GroupedListStyle())
                    .listRowSeparator(.hidden,
                                      edges: .bottom)
                    .padding(.bottom)
            }
            .searchable(text: $modelView.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .onChange(of: modelView.searchText) { _, _ in
                modelView.getPhotos()
            }
            .onAppear{
                modelView.reset()
                Task{
                    locationProvider.curentLocaiton?.placemark { placemark, error in
                        if placemark != nil {
                            modelView.searchText = "\(placemark?.city ?? ""),\(placemark?.country ?? "")"
                            modelView.getPhotos(location: locationProvider.curentLocaiton)
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    LocationBasedView()
        .environmentObject(ModelView())
}
