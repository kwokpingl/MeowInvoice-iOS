//
//  QRCodeInvoiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/20.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class QRCodeInvoiceSpec: QuickSpec {
  
  var qrCodeInvoice: QRCodeInvoice!
  
  override func spec() {
    
    context("Testing invoice properties") {
      
      self.qrCodeInvoice = {
        return QRCodeInvoice(qrCodes: ["**","TZ62958842\(105)\(10)\(11)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"])
      }()
      
      it("should have a qrCode invoice") {
        expect(self.qrCodeInvoice).toNot(beNil())
      }
      
      it("should NOT be redeemable now") {
        expect(self.qrCodeInvoice.ableToRedeem).to(equal(false))
      }
      
      it("should get proper properties.") {
        expect(self.qrCodeInvoice.fullInvoice).to(equal("TZ62958842"))
        expect(self.qrCodeInvoice.issuedDate).to(equal(Date.create(dateOnYear: 105 + 1911, month: 10, day: 11)))
        expect(self.qrCodeInvoice.invoice).to(equal(Invoice(number: 62958842)))
        expect(self.qrCodeInvoice.randomCode).to(equal("9104"))
        expect(self.qrCodeInvoice.salesAmount).to(equal("0000004B"))
        expect(self.qrCodeInvoice.totalAmount).to(equal("0000004B"))
        expect(self.qrCodeInvoice.buyerTaxIDNumber).to(equal("00000000"))
        expect(self.qrCodeInvoice.sellerTaxIDNumber).to(equal("42327458"))
        expect(self.qrCodeInvoice.sellerPersonalInfo).to(equal("**********"))
        expect(self.qrCodeInvoice.productSum).to(equal("2"))
        expect(self.qrCodeInvoice.tradeCount).to(equal("2"))
        expect(self.qrCodeInvoice.detailProductList.count).to(equal(2))
        expect(self.qrCodeInvoice.openLotteryDate).to(equal(Date.create(dateOnYear: 105+1911, month: 11, day: 25)!))
      }
      
      it("should be true now on is open lottery") {
        expect(self.qrCodeInvoice.isLotteryOpened).to(beTrue())
      }
      
      it("should no open lottery 70 days before issued date") {
        let date = self.qrCodeInvoice.issuedDate.dateBySubtractingDay(70)!
        expect(self.qrCodeInvoice.isLotteryOpened(on: date)).to(beFalse())
      }
      
      it("should not be able to redeem now") {
        expect(self.qrCodeInvoice.isRedeemExpired).to(beTrue())
      }
      
      it("should be able to redeem between redeem available time") {
        let avaFrom = self.qrCodeInvoice.redeemAvailableTime.from
        let avaTo = self.qrCodeInvoice.redeemAvailableTime.to
        expect(self.qrCodeInvoice.isRedeemExpired(on: avaFrom)).to(beFalse())
        expect(self.qrCodeInvoice.isRedeemExpired(on: avaTo)).to(beFalse())
      }
    }
    
    context("Testing init") {
      it("should fail if qrcode count is 1") {
        let qrCodeInvoice = QRCodeInvoice(qrCodes: [""])
        expect(qrCodeInvoice).to(beNil())
      }
      
      it("should fail if qrcode count is 3") {
        let qrCodeInvoice = QRCodeInvoice(qrCodes: ["", "", ""])
        expect(qrCodeInvoice).to(beNil())
      }
      
      it("should not matter if ** is left or right") {
        expect(QRCodeInvoice(qrCodes: ["**","TZ62958842\(105)\(10)\(11)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"])).toNot(beNil())
        expect(QRCodeInvoice(qrCodes: ["TZ62958842\(105)\(10)\(11)91040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40", "**"])).toNot(beNil())
      }
    }
    
  }
  
}
 
