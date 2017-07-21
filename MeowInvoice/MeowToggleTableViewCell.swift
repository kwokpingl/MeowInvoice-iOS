//
//  MeowToggleTableViewCell.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public protocol MeowToggleTableViewCellDelegate: class {
  func toggleCell(toggleDidChangeValue on: Bool)
}

final public class MeowToggleTableViewCell: UITableViewCell {
  
  @IBOutlet weak var toggleSwitch: UISwitch!
  @IBOutlet weak var contentLabel: UILabel!
  
  public var delegate: MeowToggleTableViewCellDelegate?
  
  public var otherSettingViewModel: OtherSettingViewModel? {
    didSet {
      contentLabel.text = otherSettingViewModel?.title
      toggleSwitch.isOn = otherSettingViewModel?.isOn ?? true
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    
    contentLabel
      .changeTextColor(to: MeowInvoiceColor.textColor)
      .changeFontSize(to: 17)
    
    toggleSwitch.addTarget(self,
                           action: #selector(MeowToggleTableViewCell.toggleValueChanged(toggle:)),
                           for: UIControlEvents.valueChanged)
  }
  
  @objc private func toggleValueChanged(toggle: UISwitch) {
    delegate?.toggleCell(toggleDidChangeValue: toggle.isOn)
  }
  
}
