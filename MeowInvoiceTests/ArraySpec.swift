//
//  ArraySpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/2.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class ArraySpec: QuickSpec {
    
  override func spec() {
    
    var array: [Int] = []
    
    beforeEach {
      array = [1, 2, 3]
    }
    
    it("should pop something, for 3 times") {
      expect(array.popFirst()).toNot(beNil())
      expect(array.popFirst()).toNot(beNil())
      expect(array.popFirst()).toNot(beNil())
    }
    
    it("should NOT pop after poping for 3 times") {
      array.popFirst()
      array.popFirst()
      array.popFirst()
      expect(array.popFirst()).to(beNil())
    }
    
  }
    
}
