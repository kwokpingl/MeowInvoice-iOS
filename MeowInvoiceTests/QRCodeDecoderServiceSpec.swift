//
//  QRCodeDecoderServiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class QRCodeDecoderServiceSpec: QuickSpec {
    
  override func spec() {
    let decoder = DefaultQRCodeDecoderService()
    
    it("should successfully decode given qrcodes.") {
      let code1 = ["**", "TZ62958842106052991040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q==:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"]
      expect(decoder.decode(qrCodes: code1)).toNot(beNil())
      
      let code2 = ["**", "US390294161060531619000000073000000790000000001802176CS3YtzYENN9DUqZ2BbN07Q==:**********:1:1:0:､E､GｵLｹ]:5.20:23.30"]
      expect(decoder.decode(qrCodes: code2)).toNot(beNil())
      
      let code3 = ["**", "UR485277331060531216500000000000000DA00000000530271979l1ICOgouWwDO7BQgC4rrw==:**********:1:1:1:餐飲:1:218"]
      expect(decoder.decode(qrCodes: code3)).toNot(beNil())
    }
    
    context("should NOT decode any given qrcodes") {
      it("should fail because of main information length jus 76, need 77") {
        let code1 = ["**", "TZ62958842106052991040000004B0000004B00000000423274581ddZFPeX1laqgQNOdA5c9Q=:**********:2:2:1:菠蘿:1:35:日式紅豆:1:40"]
        expect(decoder.decode(qrCodes: code1)).to(beNil())
      }
      
      it("should fail because of invalid invoice data.") {
        let code2 = ["**", "USa90294161060531619000000073000000790000000001802176CS3YtzYENN9DUqZ2BbN07Q==:**********:1:1:0:､E､GｵLｹ]:5.20:23.30"]
        expect(decoder.decode(qrCodes: code2)).to(beNil())
      }
    }
    
    context("should FAIL to create invoice") {
      it("should fail because of invalid date data") {
        let code3 = ["**", "UR485277331s60531216500000000000000DA00000000530271979l1ICOgouWwDO7BQgC4rrw==:**********:1:1:1:餐飲:1:218"]
        expect(decoder.decode(qrCodes: code3)).to(beNil())
      }
      
      it("should fail because of input code count is 3") {
        let code = ["**", "**", "UR485277331s60531216500000000000000DA00000000530271979l1ICOgouWwDO7BQgC4rrw==:**********:1:1:1:餐飲:1:218"]
        expect(decoder.decode(qrCodes: code)).to(beNil())
      }
    
      it("should fail because of input code count is 1") {
        let code = ["UR485277331s60531216500000000000000DA00000000530271979l1ICOgouWwDO7BQgC4rrw==:**********:1:1:1:餐飲:1:218"]
        expect(decoder.decode(qrCodes: code)).to(beNil())
      }

      it("should fail because encoding is nine") {
        let code3 = ["**", "UR485277331s60531216500000000000000DA00000000530271979l1ICOgouWwDO7BQgC4rrw==:**********:1:1:9:餐飲:1:218"]
        expect(decoder.decode(qrCodes: code3)).to(beNil())
      }
    }
  }
    
}
