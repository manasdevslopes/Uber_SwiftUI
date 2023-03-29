//
//  CGSize+Extensions.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 29/03/23.
//

import UIKit

extension CGSize {
  static var inactiveThumbSize: CGSize {
    return CGSize(width: 70, height: 50)
  }
  
  static var activeThumbSize: CGSize {
    return CGSize(width: 85, height: 50)
  }
  
  static var trackSize: CGSize {
    return CGSize(width: UIScreen.main.bounds.width - 32, height: 50)
  }
}
