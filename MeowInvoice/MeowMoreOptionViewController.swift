//
//  MeowMoreOptionViewController.swift
//  MeowInvoice
//
//  Created by David on 2017/6/14.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

public struct SoundSettingViewModel {
  let soundName: SoundName
  var selected: Bool
}

public struct OtherSettingViewModel {
  let title: String
  var isOn: Bool
}

final public class SettingListViewModel {
  let listCount: Int
  let sountListTitle: String
  var soundList: [SoundSettingViewModel]
  let otherSettingTitle: String
  var otherSettingList: [OtherSettingViewModel]
  
  required public init (listCount: Int, sountListTitle: String, soundList: [SoundSettingViewModel], otherSettingTitle: String, otherSettingList: [OtherSettingViewModel]) {
    self.listCount = listCount
    self.sountListTitle = sountListTitle
    self.soundList = soundList
    self.otherSettingTitle = otherSettingTitle
    self.otherSettingList = otherSettingList
  }
  
}

public protocol MeowMoreOptionView: class {
  func presentInitialContent()
  func presentSelectedSound()
}

final public class MeowMoreOptionViewController: UIViewController, MeowMoreOptionView {
  
  private var navigationBar: MeowPresentModallyNavigationBar!
  fileprivate private(set) var settingsTableView: UITableView!
  fileprivate let headerCellHeight = 54.cgFloat
  
  public var presenter: MeowMoreOptionPresenter?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    configureSettingsTableView()
    
    presenter?.loadContent()
    
    view.backgroundColor = MeowInvoiceColor.lightBackgroundColor
  }
  
  private func configureNavigationBar() {
    navigationBar = MeowPresentModallyNavigationBar(title: "設定")
    navigationBar.delegate = self
    navigationBar.anchor(to: view)
  }
  
  private func configureSettingsTableView() {
    settingsTableView = UITableView(frame: CGRect(x: 0,
                                                  y: navigationBar.bounds.height,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height - navigationBar.bounds.height))
    settingsTableView.anchor(to: view)
    settingsTableView.separatorStyle = .none
    settingsTableView.backgroundColor = .clear
    
    settingsTableView.register(cellTypes: [MeowCheckBoxTableViewCell.self, MeowToggleTableViewCell.self])
    settingsTableView.delegate = self
    settingsTableView.dataSource = self
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  public func presentInitialContent() {
    settingsTableView.reloadData()
  }
  
  public func presentSelectedSound() {
    settingsTableView.reloadData()
  }
  
}

extension MeowMoreOptionViewController : MeowPresentModallyNavigationBarDelegate {
  
  public func meowPresentModallyNavigationBarDidTapCrossButton() {
    presenter?.closeMoreOptionView()
  }
  
}

extension MeowMoreOptionViewController : UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      presenter?.savePrizeAlertSound(at: indexPath.row)
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerCellHeight
  }
  
}

extension MeowMoreOptionViewController : UITableViewDataSource {
  
  private func generateHeaderView(title: String?) -> UIView {
    let view = UIView()
      .change(width: settingsTableView.bounds.width)
      .change(height: headerCellHeight)
    let left = 16.cgFloat
    let label = UILabel()
      .changeFontSize(to: 12)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .change(height: 12)
      .change(width: settingsTableView.bounds.width - 2 * left)
      .move(10, pointsBottomToAndInside: view)
      .move(left, pointsLeadingToAndInside: view)
      .anchor(to: view)
    label.text = title
    return view
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return generateHeaderView(title: presenter?.settingsListViewModel.sountListTitle)
    } else {
      return generateHeaderView(title: presenter?.settingsListViewModel.otherSettingTitle)
    }
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return presenter?.settingsListViewModel.listCount ?? 0
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return presenter?.settingsListViewModel.soundList.count ?? 0
    } else {
      return presenter?.settingsListViewModel.otherSettingList.count ?? 0
    }
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(with: MeowCheckBoxTableViewCell.self, for: indexPath)
      cell.viewModel = presenter?.settingsListViewModel.soundList[indexPath.row]
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(with: MeowToggleTableViewCell.self, for: indexPath)
      cell.otherSettingViewModel = presenter?.settingsListViewModel.otherSettingList[indexPath.row]
      cell.delegate = self
      return cell
    }
  }
  
}

extension MeowMoreOptionViewController : MeowToggleTableViewCellDelegate {
  
  public func toggleCell(toggleDidChangeValue on: Bool) {
    presenter?.changeReceiveOpenLotteryNotification(to: on)
  }
  
}
