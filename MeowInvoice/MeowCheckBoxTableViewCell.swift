//
//  MeowCheckBoxTableViewCell.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

final public class MeowCheckBoxTableViewCell: UITableViewCell {
  
  @IBOutlet weak var meowFootPrintImageView: UIImageView!
  @IBOutlet weak var contentLabel: UILabel!
  
  public var viewModel: SoundSettingViewModel? {
    didSet {
      contentLabel.text = viewModel?.soundName.value
      guard let viewModel = viewModel else { return }
      viewModel.selected ? meowFootPrintImageView.show() : meowFootPrintImageView.hide()
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    
    meowFootPrintImageView.contentMode = .scaleAspectFill
    meowFootPrintImageView.image = #imageLiteral(resourceName: "small_meow_foot_print")
    
    contentLabel
      .changeTextColor(to: MeowInvoiceColor.textColor)
      .changeFontSize(to: 17)
    
    backgroundColor = .white
  }
  
}
