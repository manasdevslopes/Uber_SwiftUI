//
//  Double+Extensions.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 29/03/23.
//

import Foundation

extension Double {
  private var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }
  
  func toCurrency() -> String {
    return currencyFormatter.string(for: self) ?? ""
  }
}
