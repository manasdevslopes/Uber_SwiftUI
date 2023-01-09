//
//  LocationSearchViewModel.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 07/01/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
  // MARK: - Properties
  @Published var results = [MKLocalSearchCompletion]()
  @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
  
  private let searchCompleter = MKLocalSearchCompleter()
  var queryFragment: String = "" {
    didSet {
      // print("DEBUG: Query Fragment is : \(queryFragment)")
      searchCompleter.queryFragment = queryFragment
    }
  }
  
  override init() {
    super.init()
    searchCompleter.delegate = self
    searchCompleter.queryFragment = queryFragment
  }
  
  // MARK: - Helpers
  func selectedLocation(_ localSearch: MKLocalSearchCompletion) {
    locationSearch(forLocalSearchCompletion: localSearch) { response, error in
      if let error {
        print("DEBUG: Location search failed \(error.localizedDescription)")
        return
      }
      
      guard let item = response?.mapItems.first else { return }
      let coordinate = item.placemark.coordinate
      self.selectedLocationCoordinate = coordinate
      
      // print("DEBUG: Selected Location is \(String(describing: self.selectedLocationCoordinate))")
    }
}
  
  private func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
    
    let search = MKLocalSearch(request: searchRequest)
    search.start(completionHandler: completion)
  }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.results = completer.results
  }
}
