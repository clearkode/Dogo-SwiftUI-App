//
//  UIView+Additions.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 30/06/2024.
//

import Foundation
import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
