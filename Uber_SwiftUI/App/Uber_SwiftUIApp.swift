//
//  Uber_SwiftUIApp.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 07/01/23.
//

import SwiftUI

@main
struct Uber_SwiftUIApp: App {
  @StateObject var locationViewModel = LocationSearchViewModel()
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(locationViewModel)
    }
  }
}
