//
//  Comparable+Extensions.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 29/03/23.
//

import Foundation

extension Comparable {
  func clamp<T: Comparable>(lower: T, _ upper: T) -> T {
    return min(max(self as! T, lower), upper) 
  }
}
