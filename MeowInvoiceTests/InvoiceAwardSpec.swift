//
//  InvoiceAwardSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class InvoiceAwardSpec: QuickSpec {
  
  override func spec() {
    
    context("create invoice award") {
      var award: InvoiceAwards?
      
      it("should create a award", closure: { 
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: ["990"],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award).toNot(beNil())
        
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: [],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award).toNot(beNil())
      })
      
      it("should not create award if first prizes is empty", closure: { 
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: [],
                              additionSixthPrizes: [],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award).to(beNil())
      })
      
      it("should fail to create if first special prize is invalid", closure: { 
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "notvalid",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: [],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award).to(beNil())
      })
      
      it("should fail to create if special prize is invalid", closure: {
        award = InvoiceAwards(firstSpecialPrize: "notvalid",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: [],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award).to(beNil())
        award = InvoiceAwards(firstSpecialPrize: "123",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: [],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award).to(beNil())
      })
    }
    
    context("Getting short invoices") { 
      var award: InvoiceAwards?
      
      it("should get correct count of short invoices", closure: {
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: ["996"],
                              period: (year: 106, fromMonth: 3, toMonth: 4))
        expect(award!.allShortInvoices.count).to(equal(6))
      })
    }
    
    context("From month should always smaller then to month") {
      var award: InvoiceAwards?
      it("should fail when to month is smaller then from month") {
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: ["996"],
                              period: (year: 106, fromMonth: 5, toMonth: 4))
        expect(award).to(beNil())
      }
      
      it("should fail when to month is equal to from month") {
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: ["996"],
                              period: (year: 106, fromMonth: 4, toMonth: 4))
        expect(award).to(beNil())
      }
      
      it("should fail if from month is not odd") {
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: ["996"],
                              period: (year: 106, fromMonth: 4, toMonth: 5))
        expect(award).to(beNil())
      }
      
      it("should fail if to month minus from month is not 1") {
        award = InvoiceAwards(firstSpecialPrize: "12345678",
                              specialPrize: "22345678",
                              firstPrizes: ["44345678", "77345678", "66345678"],
                              additionSixthPrizes: ["996"],
                              period: (year: 106, fromMonth: 3, toMonth: 5))
        expect(award).to(beNil())
      }
    }
  }
  
}
