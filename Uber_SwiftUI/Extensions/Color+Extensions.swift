//
//  Color+Extensions.swift
//  Uber_SwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 29/03/23.
//

import SwiftUI

extension Color {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let backgroundColor = Color("BackgroundColor")
  let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
  let primaryTextColor = Color("PrimaryTextColor")
  let buttonPrimaryColor = Color("ButtonPrimaryColor")
  let buttonSecondaryColor = Color("ButtonSecondaryColor")
}
