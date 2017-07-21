//
//  ShortInvoiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class ShortInvoiceSpec: QuickSpec {
  
  override func spec() {
    
    context("initializtion") { 
      var invoice: ShortInvoice?
      
      it("should create a short invoice", closure: { 
        invoice = ShortInvoice(number: "123")
        expect(invoice).toNot(beNil())
        
        invoice = ShortInvoice(number: "000")
        expect(invoice).toNot(beNil())
      })
      
      it("should NOT create a short invoice", closure: {
        invoice = ShortInvoice(number: "12")
        expect(invoice).to(beNil())
        invoice = ShortInvoice(number: "1")
        expect(invoice).to(beNil())
        invoice = ShortInvoice(number: "1234")
        expect(invoice).to(beNil())
        invoice = ShortInvoice(number: "")
        expect(invoice).to(beNil())
      })
      
      it("should fail to create if number contains character other than numbers", closure: {
        invoice = ShortInvoice(number: "not")
        expect(invoice).to(beNil())
      })
    }
    
    context("comparing two short invoices") {
      var invoice1: ShortInvoice?
      var invoice2: ShortInvoice?
      
      it("should be equal between two invoices", closure: {
        let number = String(arc4random_uniform(899) + 100)
        invoice1 = ShortInvoice(number: number)!
        invoice2 = ShortInvoice(number: invoice1!.number)!
        
        expect(invoice1).to(equal(invoice2))
      })
    }
  }
  
}
