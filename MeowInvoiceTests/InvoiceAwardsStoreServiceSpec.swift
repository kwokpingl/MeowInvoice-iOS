//
//  InvoiceAwardsStoreServiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/20.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
import SwiftyUserDefaults
@testable import MeowInvoice

class InvoiceAwardsStoreServiceSpec: QuickSpec {
  
  override func spec() {
    let mock = MockDefaults()
    let store = DefaultInvoiceAwardsStoreService(defaults: mock)
    
    context("Check mock user defaults state") {
      it("should be empty at first") {
        expect(mock[.thisMonthFirstSpecialPrize]).to(beNil())
        expect(mock[.thisMonthSpecialPrize]).to(beNil())
        expect(mock[.thisMonthFirstPrizes]).to(beNil())
        expect(mock[.thisMonthAdditionalSixthPrize]).to(beNil())
        expect(mock[.thisMonthPeriodYear]).to(beNil())
        expect(mock[.thisMonthPeriodFromMonth]).to(beNil())
        expect(mock[.thisMonthPeriodToMonth]).to(beNil())
        
        expect(mock[.previousMonthFirstSpecialPrize]).to(beNil())
        expect(mock[.previousMonthSpecialPrize]).to(beNil())
        expect(mock[.previousMonthFirstPrizes]).to(beNil())
        expect(mock[.previousMonthAdditionalSixthPrize]).to(beNil())
        expect(mock[.previousMonthPeriodYear]).to(beNil())
        expect(mock[.previousMonthPeriodFromMonth]).to(beNil())
        expect(mock[.previousMonthPeriodToMonth]).to(beNil())
      }
      
      it("should store awards") {
        let this = InvoiceAwards(firstSpecialPrize: "12345678",
                                 specialPrize: "12345678",
                                 firstPrizes: ["12345678","12345678","12345678"],
                                 additionSixthPrizes: ["996"],
                                 period: (106,3,4))!
        let previous = InvoiceAwards(firstSpecialPrize: "12345678",
                                     specialPrize: "12345678",
                                     firstPrizes: ["12345678","12345678","12345678"],
                                     additionSixthPrizes: ["996"],
                                     period: (106,1,2))!
        
        store.updateInvoiceAwards(with: (this, previous))
        
        expect(mock[.thisMonthFirstSpecialPrize]).toNot(beNil())
        expect(mock[.thisMonthSpecialPrize]).toNot(beNil())
        expect(mock[.thisMonthFirstPrizes]).toNot(beNil())
        expect(mock[.thisMonthAdditionalSixthPrize]).toNot(beNil())
        expect(mock[.thisMonthPeriodYear]).toNot(beNil())
        expect(mock[.thisMonthPeriodFromMonth]).toNot(beNil())
        expect(mock[.thisMonthPeriodToMonth]).toNot(beNil())
        
        expect(mock[.previousMonthFirstSpecialPrize]).toNot(beNil())
        expect(mock[.previousMonthSpecialPrize]).toNot(beNil())
        expect(mock[.previousMonthFirstPrizes]).toNot(beNil())
        expect(mock[.previousMonthAdditionalSixthPrize]).toNot(beNil())
        expect(mock[.previousMonthPeriodYear]).toNot(beNil())
        expect(mock[.previousMonthPeriodFromMonth]).toNot(beNil())
        expect(mock[.previousMonthPeriodToMonth]).toNot(beNil())
      }
    }
    
  }
  
}

class MockDefaults : UserDefaults {
  
  convenience init() {
    self.init(suiteName: "Mock Defaults")!
  }
  
  override init?(suiteName suitename: String?) {
    UserDefaults().removePersistentDomain(forName: suitename!)
    super.init(suiteName: suitename)
  }
  
}
