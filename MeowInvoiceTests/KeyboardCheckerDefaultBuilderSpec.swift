//
//  KeyboardCheckerDefaultBuilderSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/20.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class KeyboardCheckerDefaultBuilderSpec: QuickSpec {
  
  override func spec() {
    it("should build default module") { 
      let builder = KeyboardCheckerDefaultBuilder()
      let module = builder.buildKeyboardCheckerModule()
      expect(module).toNot(beNil())
    }
  }
  
}
