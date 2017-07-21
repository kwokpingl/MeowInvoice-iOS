//
//  DefaultInvoiceValidationServiceSpec.swift
//  MeowInvoice
//
//  Created by David on 2017/5/31.
//  Copyright © 2017年 david. All rights reserved.
//

import Quick
import Nimble
@testable import MeowInvoice

class DefaultInvoiceValidationServiceSpec: QuickSpec {
  
  override func spec() {
    let validator = DefaultInvoiceValidationService()
    let award = InvoiceAwards(firstSpecialPrize: "74748874",
                              specialPrize: "82528918",
                              firstPrizes: ["07836485", "13410946", "96152286"],
                              additionSixthPrizes: ["996"],
                              period: (year: 106, fromMonth: 3, toMonth: 4))!
    var invoice: Invoice!
    var result: InvoiceValidationResult!
    it("should win sixth prize") {
      invoice = Invoice(number: "13410996")!
      
      result = validator.validate(invoice: invoice, with: award)
      expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.sixth)))
    }
    
    it("should like to win first special prize") { 
      invoice = Invoice(number: "74740874")!
      
      result = validator.validate(invoice: invoice, with: award)
      expect(result).to(equal(InvoiceValidationResult.noPrize))
    }
    
    it("should win sixth prize") { 
      invoice = Invoice(number: "07836996")!
      
      result = validator.validate(invoice: invoice, with: award)
      expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.sixth)))
    }
    
    it("should win fifth prize") {
      invoice = Invoice(number: "07816485")!
      
      result = validator.validate(invoice: invoice, with: award)
      expect(result).to(equal(InvoiceValidationResult.winning(prize: InvoicePrize.fifth)))
    }
    
    it("should win no prize") {
      invoice = Invoice(number: "83528918")!
      
      result = validator.validate(invoice: invoice, with: award)
      expect(result).to(equal(InvoiceValidationResult.noPrize))
    }
    
    it("should win no prize") {
      let numbers = ["39020261",
                     "74891113",
                     "60089038",
                     "39028906",
                     "95412220",
                     "98464692",
                     "39030464",
                     "60119823",
                     "47938299",
                     "47115467",
                     "60117438",
                     "60089360",
                     "26374323",
                     "39031121",
                     "60127134",
                     "71656715",
                     "42916887",
                     "39031606",
                     "21346670",
                     "05002035",
                     "13822719"]
      for number in numbers {
        invoice = Invoice(number: number)!
        
        result = validator.validate(invoice: invoice, with: award)
        expect(result).to(equal(InvoiceValidationResult.noPrize))
      }
    }
    
    it("should win no prize") {
      let numbers = ["48527318",
                     "39028601",
                     "22092293",
                     "22210202",
                     "39052079",
                     "44128210",
                     "57513385",
                     "48942365",
                     "78806997",
                     "39049416",
                     "60070336",
                     "06479532",
                     "13918491",
                     "10516570",
                     "98951044",
                     "39028328",
                     "71606238",
                     "68973713"]
      for number in numbers {
        invoice = Invoice(number: number)!
        
        result = validator.validate(invoice: invoice, with: award)
        expect(result).to(equal(InvoiceValidationResult.noPrize))
      }
    }
    
//    it("should check all prize count") {
//      var firstSpecialPrizeCount = 0
//      var specialPrizeCount = 0
//      var firstPrizeCount = 0
//      var secondPrizeCount = 0
//      var thirdPrizeCount = 0
//      var fourthPrizeCount = 0
//      var fifthPrizeCount = 0
//      var sixthPrizeCount = 0
//      var noPrizeCount = 0
//      
//      let allPrizeCount = Int(pow(10.0, 8.0)) - 1 // 99,999,999
//      
//      let segements = 10
//      let segmentCount = (allPrizeCount + 1) / segements
//      for i in 0..<segements {
//        
//        let range = { () -> CountableClosedRange<Int> in
//          if i + 1 == segements {
//            // last
//            return (i * segmentCount)...((i + 1) * segmentCount - 1)
//          } else {
//            return (i * segmentCount)...((i + 1) * segmentCount)
//          }
//        }()
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
//          for number in range {
//            print("queue \(i), \(number) left")
//            
//            guard let invoice = Invoice(number: number) else { continue }
//            expect(invoice).toNot(beNil())
//            let result = validator.validate(invoice: invoice, with: award)
//            
//            switch result {
//            case let InvoiceValidationResult.winning(prize: prize):
//              switch prize {
//              case .firstSpecial: firstSpecialPrizeCount += 1
//              case .special: specialPrizeCount += 1
//              case .first: firstPrizeCount += 1
//              case .second: secondPrizeCount += 1
//              case .third: thirdPrizeCount += 1
//              case .fourth: fourthPrizeCount += 1
//              case .fifth: fifthPrizeCount += 1
//              case .sixth: sixthPrizeCount += 1
//              }
//            case InvoiceValidationResult.noPrize:
//              noPrizeCount += 1
//            case InvoiceValidationResult.seemsLikeWinningAPrize:
//              fail()
//            }
//          }
//        }
//      }
//      
//      // check count
//      let actualFirstSpecialPrizeCount = 1
//      let actualSpecialPrizeCount = 1
//      let actualFirstPrizeCount = 3
//      let actualSecondPrizeCount = 3 * 9
//      let actualThirdPrizeCount = 3 * 9 * 10
//      let actualFourthPrizeCount = 3 * 9 * 10 * 10
//      let actualFifthPrizeCount = 3 * 9 * 10 * 10 * 10
//      let actualSixthPrizeCount = 3 * 9 * 10 * 10 * 10 * 10
//      expect(firstSpecialPrizeCount).toEventually(equal(actualFirstSpecialPrizeCount),
//                                                  timeout: 9000,
//                                                  pollInterval: 5,
//                                                  description: "fail!!!!!")
//      expect(specialPrizeCount).toEventually(equal(actualSpecialPrizeCount),
//                                             timeout: 9000,
//                                             pollInterval: 5,
//                                             description: "fail!!!!!")
//      expect(firstPrizeCount).toEventually(equal(actualFirstPrizeCount),
//                                           timeout: 9000,
//                                           pollInterval: 5,
//                                           description: "fail!!!!!")
//      expect(secondPrizeCount).toEventually(equal(actualSecondPrizeCount),
//                                            timeout: 9000,
//                                            pollInterval: 5,
//                                            description: "fail!!!!!")
//      expect(thirdPrizeCount).toEventually(equal(actualThirdPrizeCount),
//                                           timeout: 9000,
//                                           pollInterval: 5,
//                                           description: "fail!!!!!")
//      expect(fourthPrizeCount).toEventually(equal(actualFourthPrizeCount),
//                                            timeout: 9000,
//                                            pollInterval: 5,
//                                            description: "fail!!!!!")
//      expect(fifthPrizeCount).toEventually(equal(actualFifthPrizeCount),
//                                           timeout: 9000,
//                                           pollInterval: 5,
//                                           description: "fail!!!!!")
//      
//      let additionSixthPrizeCount = Int(pow(10.0, 5)) * award.additionSixthPrizes.count
//      expect(sixthPrizeCount).toEventually(equal(actualSixthPrizeCount + additionSixthPrizeCount),
//                                           timeout: 9000,
//                                           pollInterval: 5,
//                                           description: "fail!!!!!")
//    }
  }
  
}
