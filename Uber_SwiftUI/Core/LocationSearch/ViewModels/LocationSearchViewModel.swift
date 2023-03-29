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
  @Published var selectedUberLocation: UberLocation?
  @Published var pickupTime: String?
  @Published var dropoffTime: String?
  
  private let searchCompleter = MKLocalSearchCompleter()
  var queryFragment: String = "" {
    didSet {
      // print("DEBUG: Query Fragment is : \(queryFragment)")
      searchCompleter.queryFragment = queryFragment
    }
  }
  
  /// - User's Current Location
  var userLocation: CLLocationCoordinate2D?
  
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
      self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
      
      // print("DEBUG: Selected Location is \(String(describing: self.selectedLocationCoordinate))")
    }
  }
  
  private func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
    
    let search = MKLocalSearch(request: searchRequest)
    search.start(completionHandler: completion)
  }
  
  func computeRidePrice(forType type: RideType) -> Double {
    /// - destination location coordinate
    guard let selectedCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
    guard let userCoordinate = self.userLocation else { return 0.0 } /// - User's current location
    /// - Now putting all lat and lon from both coordinates into CLLocation
    let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
    let destination = CLLocation(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude)
    /// - Now calculate distance b/w userlocation and destination
    let tripDistanceInMeters = userLocation.distance(from: destination)
    return type.computePrice(for: tripDistanceInMeters)
  }
  
  func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> ()) {
    let userPlacemark = MKPlacemark(coordinate: userLocation)
    let destPlacemark = MKPlacemark(coordinate: destination)
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: userPlacemark)
    request.destination = MKMapItem(placemark: destPlacemark)
    let directions = MKDirections(request: request)
    
    directions.calculate { response, error in
      if let error {
        print("DEBUG: Failed to get directions ----> \(error.localizedDescription)")
        return
      }
      guard let route = response?.routes.first else { return }
      self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
      completion(route)
    }
  }
  
  private func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    
    pickupTime = formatter.string(from: Date())
    dropoffTime = formatter.string(from: Date() + expectedTravelTime)
  }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.results = completer.results
  }
}
