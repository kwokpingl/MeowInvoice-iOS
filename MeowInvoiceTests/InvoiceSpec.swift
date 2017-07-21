//
//  InvoiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class InvoiceSpec: QuickSpec {
    
  override func spec() {
    
    context("Initialization") { 
      var invoice: Invoice?
      
      it("should create a invoice", closure: { 
        invoice = Invoice(number: "12345678")
        expect(invoice).notTo(beNil())
      })
      
      it("should be nil on those inits", closure: {
        invoice = Invoice(number: "123456789")
        expect(invoice).to(beNil())
        invoice = Invoice(number: "1234567890")
        expect(invoice).to(beNil())
        invoice = Invoice(number: "123")
        expect(invoice).to(beNil())
        invoice = Invoice(number: "12")
        expect(invoice).to(beNil())
        invoice = Invoice(number: "1")
        expect(invoice).to(beNil())
      })
      
//      it("should not be all zeros", closure: { 
//        invoice = Invoice(number: "00000000")
//        expect(invoice).to(beNil())
//      })
      
      it("should fail to create if number contains character other than numbers", closure: { 
        invoice = Invoice(number: "notvalid")
        expect(invoice).to(beNil())
      })
      
      it("should create a invoice using a Int", closure: { 
        invoice = Invoice(number: 1)
        expect(invoice).toNot(beNil())
        
        invoice = Invoice(number: 8751)
        expect(invoice).toNot(beNil())
      })
      
      it("should NOT create a invoice using 0 Int as input", closure: {
        invoice = Invoice(number: 0)
        expect(invoice).to(beNil())
      })
      
      it("should NOT create a invoice using number greater than 10^9 Int as input", closure: {
        invoice = Invoice(number: Int(pow(11.0, 9)))
        expect(invoice).to(beNil())
      })
      
    }
    
    context("getting short invoice from invoice") { 
      var invoice: Invoice?
      
      it("should get a short invoice and equal to last 3 letters", closure: { 
        invoice = Invoice(number: "12345678")
        expect(invoice).notTo(beNil())
        
        expect(invoice!.shortInvoice.number).to(equal(invoice!.number.last(3)))
      })
    }
    
    context("comparing invoices") { 
      var invoice1: Invoice?
      var invoice2: Invoice?
      
      it("should be equal between two invoices", closure: { 
        invoice1 = Invoice(number: "12345678")!
        invoice2 = Invoice(number: "12345678")!
        
        expect(invoice1).to(equal(invoice2))
      })
      
      it("should NOT be equal between two invoices", closure: {
        invoice1 = Invoice(number: "12345678")!
        invoice2 = Invoice(number: "12345679")!
        
        expect(invoice1).toNot(equal(invoice2))
      })
    }
    
    context("comparing to another invoice") { 
      var invoice1: Invoice! = Invoice(number: "12345678")!
      var invoice2: Invoice! = Invoice(number: "12345678")!
      
      it("should get first price", closure: {
        invoice2 = Invoice(number: "12345678")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.first)))
      })
      
      it("should get second price", closure: {
        invoice2 = Invoice(number: "22345678")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.second)))
      })
      
      it("should get third price", closure: {
        invoice2 = Invoice(number: "20345678")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.third)))
      })
      
      it("should get fourth price", closure: {
        invoice2 = Invoice(number: "22045678")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.fourth)))
      })
      
      it("should get fifth price", closure: {
        invoice2 = Invoice(number: "22305678")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.fifth)))
      })
      
      it("should get sixth price", closure: {
        invoice2 = Invoice(number: "22340678")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.sixth)))
      })
      
      it("should get no price", closure: {
        invoice2 = Invoice(number: "22340078")!
        let result = invoice1.comparing(to: invoice2)
        expect(result).to(equal(InvoiceValidationResult.noPrize))
      })
    }
    
  }
    
}
