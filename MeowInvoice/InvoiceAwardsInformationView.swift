//
//  InvoiceAwardsInformationView.swift
//  MeowInvoice
//
//  Created by David on 2017/6/7.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

final public class InvoiceAwardsInformationView: UIView {
  
  private let forumLeftMargin = 24.cgFloat
  private let prizeTitleWidth = 56.cgFloat
  private let contentLeftMargin = 16.cgFloat
  private let contentDetailSpacing = 8.cgFloat
  private let contentFontSize = 24.cgFloat
  
  private var contentLabelMaxWidth: CGFloat {
    return bounds.width - ((forumLeftMargin + contentLeftMargin) * 2 + prizeTitleWidth)
  }
  
  private var additionSixthPrizeTitleLabel: UILabel!
  private var additionSixthPrizeContentLabel: UILabel!
  private var additionSixthPrizeDetailLabel: UILabel!
  
  private var firstPrizeTitleLabel: UILabel!
  private var firstPrizeContentLabel: UILabel!
  private var firstPrizeDetailLabel: UILabel!
  
  private var firstSpecialPrizeTitleLabel: UILabel!
  private var firstSpecialPrizeContentLabel: UILabel!
  private var firstSpecialPrizeDetailLabel: UILabel!
  
  private var specialPrizeTitleLabel: UILabel!
  private var specialPrizeContentLabel: UILabel!
  private var specialPrizeDetailLabel: UILabel!
  
  private var secondPrizeTitleLabel: UILabel!
  private var secondPrizeDetailLabel: UILabel!
  
  private var thirdPrizeTitleLabel: UILabel!
  private var thirdPrizeDetailLabel: UILabel!
  
  private var fourthPrizeTitleLabel: UILabel!
  private var fourthPrizeDetailLabel: UILabel!
  
  private var fifthPrizeTitleLabel: UILabel!
  private var fifthPrizeDetailLabel: UILabel!
  
  private var sixthPrizeTitleLabel: UILabel!
  private var sixthPrizeDetailLabel: UILabel!
  
  private var invoiceAwards: InvoiceAwards!
  
  // MARK: - Init
  public convenience init(width: CGFloat, invoiceAwards: InvoiceAwards) {
    self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 700)))
    
    self.invoiceAwards = invoiceAwards
    
    configureAdditionSixthPrizeLabels()
    configureFirstPrizeLabels()
    configureFirstSpecialPrizeLabels()
    configureSpecialPrizeLabels()
    configureSecondPrizeLabels()
    configureThirdPrizeLabels()
    configureFourthPrizeLabels()
    configureFifthPrizeLabels()
    configureSixthPrizeLabels()
    
    frame.size.height = sixthPrizeTitleLabel.frame.maxY + forumLeftMargin
    
    configureLeftLine()
    configureMiddleLine()
    configureRightLine()
    configureHorizontalLines()
    
    change(cornerRadius: 8)
    backgroundColor = .white
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func generateContentLabel(text: String) -> UILabel {
    let fontSize: CGFloat = contentFontSize
    let prizeContentLabelHeight = text.preferredTextHeight(withConstrainedWidth: contentLabelMaxWidth, andFontSize: fontSize)
    let label = UILabel()
      .changeTextColor(to: .black)
      .changeFontSize(to: fontSize)
      .changeNumberOfLines(to: 0)
      .change(width: contentLabelMaxWidth)
      .change(height: prizeContentLabelHeight)
    label.text = text
    return label
  }
  
  private func generateDetailLabel() -> UILabel {
    let fontSize: CGFloat = 14
    return
      UILabel()
        .changeFontSize(to: fontSize)
        .changeTextColor(to: MeowInvoiceColor.darkTextColor)
        .change(width: contentLabelMaxWidth)
        .change(height: fontSize)
  }
  
  private func generateTitleLabel() -> UILabel {
    return
      UILabel()
        .changeFontSize(to: 14)
        .changeNumberOfLines(to: 0)
        .changeTextAlignment(to: .center)
        .changeTextColor(to: MeowInvoiceColor.darkTextColor)
        .change(width: prizeTitleWidth)
  }
  
  private func configureAdditionSixthPrizeLabels() {
    let additionSixthPrizeContentLabelText = invoiceAwards.additionSixthPrizes.reduce("", { (result, invoice) -> String in
      if invoice == invoiceAwards.additionSixthPrizes.last {
        return result + invoice.number
      } else {
        return result + invoice.number + "、"
      }
    })
    additionSixthPrizeContentLabel = generateContentLabel(text: additionSixthPrizeContentLabelText).changeTextColor(to: .red).anchor(to: self)
    
    additionSixthPrizeDetailLabel = generateDetailLabel().anchor(to: self)
    additionSixthPrizeDetailLabel.text = "後 3 碼全中 200 元"
    
    additionSixthPrizeContentLabel
      .move(forumLeftMargin + contentLeftMargin, pointsTrailingToAndInside: self)
      .move(forumLeftMargin + contentLeftMargin, pointsTopToAndInside: self)
    additionSixthPrizeDetailLabel
      .move(contentDetailSpacing, pointBelow: additionSixthPrizeContentLabel)
      .move(forumLeftMargin + contentLeftMargin, pointsTrailingToAndInside: self)
    
    let height =
      contentLeftMargin * 2 +
        contentDetailSpacing +
        additionSixthPrizeContentLabel.bounds.height +
        additionSixthPrizeDetailLabel.bounds.height
    
    additionSixthPrizeTitleLabel = generateTitleLabel()
      .change(height: height)
      .move(forumLeftMargin, pointsTopToAndInside: self)
      .move(forumLeftMargin, pointsLeadingToAndInside: self)
      .anchor(to: self)
    additionSixthPrizeTitleLabel.text = "增開\n六獎"
  }
  
  private func configureFirstPrizeLabels() {
    configureContentLabelAndDetailLabels(contentLabel: &firstPrizeContentLabel,
                                         contentLabelText: "--------\n--------\n--------",
                                         detailLabel: &firstPrizeDetailLabel,
                                         detailLabelText: "8 碼全中 20 萬元",
                                         titleLabel: &firstPrizeTitleLabel,
                                         titleLabelText: "頭獎",
                                         previousDetailLabel: additionSixthPrizeDetailLabel,
                                         previousTitleLabel: additionSixthPrizeTitleLabel)
    firstPrizeContentLabel.attributedText = generateFirstPrizeStrings(numbers: invoiceAwards.firstPrizes.map({ $0.number }))
  }
  
  private func configureFirstSpecialPrizeLabels() {
    configureContentLabelAndDetailLabels(contentLabel: &firstSpecialPrizeContentLabel,
                                         contentLabelText: invoiceAwards.firstSpecialPrize.number,
                                         detailLabel: &firstSpecialPrizeDetailLabel,
                                         detailLabelText: "8 碼全中 1,000 萬元",
                                         titleLabel: &firstSpecialPrizeTitleLabel,
                                         titleLabelText: "特別獎",
                                         previousDetailLabel: firstPrizeDetailLabel,
                                         previousTitleLabel: firstPrizeTitleLabel)
    firstSpecialPrizeContentLabel.attributedText = generateAllRedPrizeString(number: invoiceAwards.firstSpecialPrize.number)
  }
  
  private func configureSpecialPrizeLabels() {
    configureContentLabelAndDetailLabels(contentLabel: &specialPrizeContentLabel,
                                         contentLabelText: invoiceAwards.specialPrize.number,
                                         detailLabel: &specialPrizeDetailLabel,
                                         detailLabelText: "8 碼全中 200 萬元",
                                         titleLabel: &specialPrizeTitleLabel,
                                         titleLabelText: "特獎",
                                         previousDetailLabel: firstSpecialPrizeDetailLabel,
                                         previousTitleLabel: firstSpecialPrizeTitleLabel)
    specialPrizeContentLabel.attributedText = generateAllRedPrizeString(number: invoiceAwards.specialPrize.number)
  }
  
  private func configureSecondPrizeLabels() {
    configureDetailLabels(detailLabel: &secondPrizeDetailLabel,
                          detailLabelText: "頭獎號碼後 7 碼全中 4 萬元",
                          titleLabel: &secondPrizeTitleLabel,
                          titleLabelText: "二獎",
                          previousDetailLabel: specialPrizeDetailLabel,
                          previousTitleLabel: specialPrizeTitleLabel)
  }
  
  private func configureThirdPrizeLabels() {
    configureDetailLabels(detailLabel: &thirdPrizeDetailLabel,
                          detailLabelText: "頭獎號碼後 6 碼全中 1 萬元",
                          titleLabel: &thirdPrizeTitleLabel,
                          titleLabelText: "三獎",
                          previousDetailLabel: secondPrizeDetailLabel,
                          previousTitleLabel: secondPrizeTitleLabel)
  }
  
  private func configureFourthPrizeLabels() {
    configureDetailLabels(detailLabel: &fourthPrizeDetailLabel,
                          detailLabelText: "頭獎號碼後 5 碼全中 4,000 元",
                          titleLabel: &fourthPrizeTitleLabel,
                          titleLabelText: "四獎",
                          previousDetailLabel: thirdPrizeDetailLabel,
                          previousTitleLabel: thirdPrizeTitleLabel)
  }
  
  private func configureFifthPrizeLabels() {
    configureDetailLabels(detailLabel: &fifthPrizeDetailLabel,
                          detailLabelText: "頭獎號碼後 4 碼全中 1,000 元",
                          titleLabel: &fifthPrizeTitleLabel,
                          titleLabelText: "五獎",
                          previousDetailLabel: fourthPrizeDetailLabel,
                          previousTitleLabel: fourthPrizeTitleLabel)
  }
  
  private func configureSixthPrizeLabels() {
    configureDetailLabels(detailLabel: &sixthPrizeDetailLabel,
                          detailLabelText: "頭獎號碼後 3 碼全中 200 元",
                          titleLabel: &sixthPrizeTitleLabel,
                          titleLabelText: "六獎",
                          previousDetailLabel: fifthPrizeDetailLabel,
                          previousTitleLabel: fifthPrizeTitleLabel)
  }
  
  private func configureContentLabelAndDetailLabels(contentLabel: inout UILabel!, contentLabelText: String, detailLabel: inout UILabel!, detailLabelText: String, titleLabel: inout UILabel!, titleLabelText: String, previousDetailLabel: UILabel, previousTitleLabel: UILabel) {
    contentLabel = generateContentLabel(text: contentLabelText).anchor(to: self)
    
    detailLabel = generateDetailLabel().anchor(to: self)
    detailLabel.text = detailLabelText
    
    contentLabel
      .move(contentLeftMargin * 2, pointBelow: previousDetailLabel)
      .move(forumLeftMargin + contentLeftMargin, pointsTrailingToAndInside: self)
    detailLabel
      .move(contentDetailSpacing, pointBelow: contentLabel)
      .move(forumLeftMargin + contentLeftMargin, pointsTrailingToAndInside: self)
    
    let height = contentLeftMargin * 2 + contentDetailSpacing + contentLabel.bounds.height + detailLabel.bounds.height
    
    titleLabel = generateTitleLabel().anchor(to: self)
      .change(height: height)
      .move(0, pointBelow: previousTitleLabel)
      .move(forumLeftMargin, pointsLeadingToAndInside: self)
    titleLabel.text = titleLabelText
  }
  
  private func generateLast3RedCharactersString(string: String) -> NSAttributedString {
    guard string.characters.count == 8 else { return NSAttributedString() }
    let frontPartAttrubute = [NSFontAttributeName: UIFont.systemFont(ofSize: contentFontSize), NSForegroundColorAttributeName: UIColor.black]
    let frontPartString = NSMutableAttributedString(string: string.string(from: 0, to: 4), attributes: frontPartAttrubute)
    let secondPartAttrubute = [NSFontAttributeName: UIFont.systemFont(ofSize: contentFontSize), NSForegroundColorAttributeName: UIColor.red]
    let secondPartString = NSAttributedString(string: string.string(from: 5, to: 7), attributes: secondPartAttrubute)
    frontPartString.append(secondPartString)
    
    return frontPartString
  }
  
  private func generateFirstPrizeStrings(numbers: [String]) -> NSAttributedString {
    let returnString = NSMutableAttributedString(string: "")
    for (index, number) in numbers.enumerated() {
      returnString.append(generateLast3RedCharactersString(string: number))
      if index < numbers.endIndex - 1 {
        returnString.append(NSAttributedString(string: "\n"))
      }
    }
    
    return returnString
  }
  
  private func generateAllRedPrizeString(number: String) -> NSAttributedString {
    guard number.characters.count == 8 else { return NSAttributedString() }
    let frontPartAttrubute = [NSFontAttributeName: UIFont.systemFont(ofSize: contentFontSize), NSForegroundColorAttributeName: UIColor.red]
    let frontPartString = NSMutableAttributedString(string: number, attributes: frontPartAttrubute)
    
    return frontPartString
  }
  
  private func configureDetailLabels(detailLabel: inout UILabel!, detailLabelText: String, titleLabel: inout UILabel!, titleLabelText: String, previousDetailLabel: UILabel, previousTitleLabel: UILabel) {
    
    detailLabel = generateDetailLabel().anchor(to: self)
    detailLabel.text = detailLabelText
    
    detailLabel
      .move(contentLeftMargin * 2, pointBelow: previousDetailLabel)
      .move(forumLeftMargin + contentLeftMargin, pointsTrailingToAndInside: self)
    
    let height = contentLeftMargin * 2 + detailLabel.bounds.height
    
    titleLabel = generateTitleLabel().anchor(to: self)
      .change(height: height)
      .move(0, pointBelow: previousTitleLabel)
      .move(forumLeftMargin, pointsLeadingToAndInside: self)
    titleLabel.text = titleLabelText
  }
  
  private func configureLeftLine() {
    generateVerticalLine()
      .move(forumLeftMargin, pointsTopToAndInside: self)
      .move(forumLeftMargin, pointsLeadingToAndInside: self)
      .anchor(to: self)
  }
  
  private func configureRightLine() {
    generateVerticalLine()
      .move(forumLeftMargin, pointsTopToAndInside: self)
      .move(forumLeftMargin, pointsTrailingToAndInside: self)
      .anchor(to: self)
  }
  
  private func configureMiddleLine() {
    generateVerticalLine()
      .move(forumLeftMargin, pointsTopToAndInside: self)
      .move(0, pointsRightFrom: additionSixthPrizeTitleLabel)
      .anchor(to: self)
  }
  
  private func configureHorizontalLines() {
    // top line
    generateHorizontalLine()
      .move(0, pointTopOf: additionSixthPrizeTitleLabel)
      .move(forumLeftMargin, pointsLeadingToAndInside: self)
      .anchor(to: self)
    // other lines.
    let titleLabels: [UILabel] = [additionSixthPrizeTitleLabel, firstPrizeTitleLabel, firstSpecialPrizeTitleLabel, specialPrizeTitleLabel, secondPrizeTitleLabel, thirdPrizeTitleLabel, fourthPrizeTitleLabel, fifthPrizeTitleLabel, sixthPrizeTitleLabel]
    titleLabels.forEach {
      generateHorizontalLine()
        .move(0, pointBelow: $0)
        .move(forumLeftMargin, pointsLeadingToAndInside: self)
        .anchor(to: self)
    }
  }
  
  private func generateVerticalLine() -> UIView {
    let line = UIView()
      .change(width: 1)
      .change(height: bounds.height - 2 * forumLeftMargin)
    line.backgroundColor = MeowInvoiceColor.mainOrange
    return line
  }
  
  private func generateHorizontalLine() -> UIView {
    let line = UIView()
      .change(width: bounds.width - 2 * forumLeftMargin)
      .change(height: 1)
    line.backgroundColor = MeowInvoiceColor.mainOrange
    return line
  }
  
}
