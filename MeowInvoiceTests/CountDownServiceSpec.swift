//
//  CountDownServiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/6.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class CountDownServiceSpec: QuickSpec {
  
  override func spec() {
    
    context("Testing given date and get right period") {
      var date: Date!
      let countDownService = DefaultOpenLotteryCountDownService()
      
      it("should get 1/25 - 3/25 given 2/20") {
        date = Date.create(dateOnYear: 2017, month: 2, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2017))
        expect(this.month).to(equal(1))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2017))
        expect(next.month).to(equal(3))
        expect(next.day).to(equal(25))
      }
      
      it("should get 3/25 - 5/25 given 4/20") {
        date = Date.create(dateOnYear: 2017, month: 4, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2017))
        expect(this.month).to(equal(3))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2017))
        expect(next.month).to(equal(5))
        expect(next.day).to(equal(25))
      }
      
      it("should get 5/25 - 7/25 given 6/20") {
        date = Date.create(dateOnYear: 2017, month: 6, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2017))
        expect(this.month).to(equal(5))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2017))
        expect(next.month).to(equal(7))
        expect(next.day).to(equal(25))
      }
      
      it("should get 7/25 - 9/25 given 8/20") {
        date = Date.create(dateOnYear: 2017, month: 8, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2017))
        expect(this.month).to(equal(7))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2017))
        expect(next.month).to(equal(9))
        expect(next.day).to(equal(25))
      }
      
      it("should get 9/25 - 11/25 given 10/20") {
        date = Date.create(dateOnYear: 2017, month: 10, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2017))
        expect(this.month).to(equal(9))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2017))
        expect(next.month).to(equal(11))
        expect(next.day).to(equal(25))
      }
      
      it("should get 11/25 - next year 1/25 given 12/20") {
        date = Date.create(dateOnYear: 2017, month: 12, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2017))
        expect(this.month).to(equal(11))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2018))
        expect(next.month).to(equal(1))
        expect(next.day).to(equal(25))
      }
      
      it("should get previous 11/25 - this year 1/25 given 1/20") {
        date = Date.create(dateOnYear: 2017, month: 1, day: 20)
        let this = countDownService.thisOpenLotteryDate(of: date)
        let next = countDownService.nextOpenLotteryDate(of: date)
        expect(this.year).to(equal(2016))
        expect(this.month).to(equal(11))
        expect(this.day).to(equal(25))
        expect(next.year).to(equal(2017))
        expect(next.month).to(equal(1))
        expect(next.day).to(equal(25))
      }
      
    }
  }
  
}
