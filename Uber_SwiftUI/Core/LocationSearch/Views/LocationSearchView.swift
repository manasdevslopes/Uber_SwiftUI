//
//  LocationSearchView.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 07/01/23.
//

import SwiftUI

struct LocationSearchView: View {
  @State private var startLocationText = ""
  @Binding var mapState: MapViewState
  @EnvironmentObject var viewModel: LocationSearchViewModel
  
  var body: some View {
    VStack {
      // header View
      HStack {
        VStack {
          Circle().fill(Color(.systemGray3)).frame(width: 6, height: 6)
          
          Rectangle().fill(Color(.systemGray3)).frame(width: 1, height: 24)
          
          Rectangle().fill(.black).frame(width: 6, height: 6)
        }
        
        VStack {
          TextField("Current Location", text: $startLocationText)
            .frame(height: 32).padding(.horizontal, 6).background(Color(.systemGroupedBackground))
            .padding(.trailing)
          
          TextField("Where to?", text: $viewModel.queryFragment)
            .frame(height: 32).padding(.horizontal, 6).background(Color(.systemGray4)).padding(.trailing)
        }
      }
      .padding(.horizontal)
      .padding(.top, 64)
      
      Divider().padding(.vertical)
      
      // List View
      ScrollView {
        VStack(alignment: .leading) {
          ForEach(viewModel.results, id:\.self) { result in
            LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
              .onTapGesture {
                withAnimation(.spring()) {
                  viewModel.selectedLocation(result)
                  mapState = .locationSelected
                  viewModel.queryFragment = ""
                }
              }
          }
          if viewModel.results.isEmpty {
            Text("Where you want to go?")
          }
        }
      }
    }
    .background(Color.theme.backgroundColor)
  }
}

struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(mapState: .constant(.searchingForLocation))
      .environmentObject(LocationSearchViewModel())
  }
}
