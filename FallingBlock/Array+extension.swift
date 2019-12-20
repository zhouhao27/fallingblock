//
//  Array+extension.swift
//  FallingBlock
//
//  Created by Hao Zhou on 20/12/19.
//  Copyright © 2019 Hao Zhou. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  
  // Remove first collection element that is equal to the given `object`:
  mutating func remove(object: Element) {
    guard let index = firstIndex(of: object) else {return}
    remove(at: index)
  }
  
}
