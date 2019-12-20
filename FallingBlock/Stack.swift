//
//  Stack.swift
//  FallingBlock
//
//  Created by Hao Zhou on 20/12/19.
//  Copyright © 2019 Hao Zhou. All rights reserved.
//

import Foundation

struct Stack<Element> {
  fileprivate var array: [Element] = []
  
  mutating func push(_ element: Element) {
    array.append(element)
  }
  
  mutating func pop() -> Element? {    
    return array.popLast()
  }
  
  func peek() -> Element? {
    return array.last
  }
  
  mutating func removeAll() {
    array.removeAll()
  }
}

