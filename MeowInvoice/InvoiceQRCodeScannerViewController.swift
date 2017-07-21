//
//  InvoiceQRCodeScannerViewController.swift
//  MeowInvoice
//
//  Created by David on 2017/6/1.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit
import AVFoundation

public protocol InvoiceQRCodeScannerView: class {
  func displayScanResult(_ viewModel: InvoiceQRCodeScanResultViewModel)
}

final public class InvoiceQRCodeScannerViewController: UIViewController, InvoiceQRCodeScannerView {
  
  public var presenter: InvoiceQRCodeScannerPresenter?
  
  fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  private var videoPreviewView: UIView!
  private var resultLabel: UILabel!
  private var detailResultLabel: UILabel!
  private var bottomLeftHintLabel: UILabel!
  private var subtitleLabel: UILabel!
  private var detailSubtitleLabel: UILabel!
  private var meowImageView: UIImageView!
  
  fileprivate var qrCodeFrameViews: (first: UIView, second: UIView)!
  private var captureSession: AVCaptureSession?
  fileprivate let supportedBarCodes = [AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeAztecCode]
  
  private var emptyStateTitleLabel: UILabel?
  private var emptyStateSubtitleLabel: UILabel?
  private var emptyStateOpenCameraButton: UIButton?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureVideoPreviewLayer()
    configureQRCodeFrameViews()
    configureLabelsOnVideoPreviewView()
    configureSubtitles()
    configureMeowImageView()
    
    view.backgroundColor = MeowInvoiceColor.lightBackgroundColor
  }
  
  public func startCapturingQRCode() {
    captureSession?.startRunning()
  }
  
  public func stopCapturingQRCode() {
    captureSession?.stopRunning()
  }
  
  public override func willMove(toParentViewController parent: UIViewController?) {
    super.willMove(toParentViewController: parent)
    captureSession?.stopRunning()
  }
  
  public override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    
    // to handle transitioning state.
    parent == nil ? captureSession?.stopRunning() : captureSession?.startRunning()
    
    rearrangeSubviews()
  }
  
  public func rearrangeSubviews() {
    meowImageView.move(-50, pointsBottomToAndInside: view)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    captureSession?.startRunning()
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    captureSession?.stopRunning()
  }
  
  // MARK: - View configuration
  private func configureVideoPreviewLayer() {
    // init preview view
    videoPreviewView = UIView()
    videoPreviewView.frame.size.width = view.bounds.width
    videoPreviewView.frame.size.height = view.bounds.width * 0.8
    videoPreviewView.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    do {
      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice)
      
      // Initialize the captureSession object.
      captureSession = AVCaptureSession()
      // Set the input device on the capture session.
      captureSession?.addInput(input)
      
      // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession?.addOutput(captureMetadataOutput)
      
      // Set delegate and use the default dispatch queue to execute the call back
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      
      // Detect all the supported bar code
      captureMetadataOutput.metadataObjectTypes = supportedBarCodes
      
      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
      videoPreviewLayer?.frame = videoPreviewView.layer.bounds
      videoPreviewView.layer.addSublayer(videoPreviewLayer!)
      videoPreviewView.clipedToBounds()
      
      view.addSubview(videoPreviewView)
    } catch let e {
      print(e)
      configureEmptyStateViews()
    }
  }
  
  private func configureQRCodeFrameViews() {
    // Initialize QR Code Frame to highlight the QR code
    qrCodeFrameViews = (UIView(), UIView())
    [qrCodeFrameViews.first, qrCodeFrameViews.second].forEach {
      $0.layer.borderColor = MeowInvoiceColor.mainOrange.cgColor
      $0.layer.borderWidth = 2
      videoPreviewView.addSubview($0)
      videoPreviewView.bringSubview(toFront: $0)
    }
  }
  
  private func configureLabelsOnVideoPreviewView() {
    let leftMargin = 24.cgFloat
    resultLabel = UILabel()
      .changeTextAlignment(to: .right)
      .changeTextColor(to: MeowInvoiceColor.mainOrange)
      .addTextShadow(shadowOpacity: 0.5, shadowRadius: 4, shadowColor: UIColor.black, shadowOffset: CGSize(width: 0, height: 2))
      .changeFontSize(to: 48)
      .change(height: 48)
      .change(width: videoPreviewView.bounds.width - 2 * leftMargin)
      .move(24, pointsTopToAndInside: videoPreviewView)
      .centerX(inside: videoPreviewView)
      .anchor(to: videoPreviewView)
    
    detailResultLabel = UILabel()
      .changeTextAlignment(to: .right)
      .changeTextColor(to: MeowInvoiceColor.mainOrange)
      .addTextShadow(shadowOpacity: 0.5, shadowRadius: 4, shadowColor: UIColor.black, shadowOffset: CGSize(width: 0, height: 2))
      .changeFontSize(to: 16)
      .change(height: 16)
      .change(width: videoPreviewView.bounds.width - 2 * leftMargin)
      .move(12, pointBelow: resultLabel)
      .centerX(inside: videoPreviewView)
      .anchor(to: videoPreviewView)
    
    bottomLeftHintLabel = UILabel()
      .changeTextAlignment(to: .left)
      .changeTextColor(to: MeowInvoiceColor.mainOrange)
      .changeFontSize(to: 16)
      .addTextShadow(shadowOpacity: 0.5, shadowRadius: 4, shadowColor: UIColor.black, shadowOffset: CGSize(width: 0, height: 2))
      .change(height: 16)
      .change(width: videoPreviewView.bounds.width)
      .move(leftMargin, pointsBottomToAndInside: videoPreviewView)
      .move(leftMargin, pointsLeadingToAndInside: videoPreviewView)
      .anchor(to: videoPreviewView)
    bottomLeftHintLabel.text = "對準兩個 QR-CODE"
  }
  
  private func configureSubtitles() {
    let subtitleLabelFontSize = 32.cgFloat
    subtitleLabel = UILabel()
      .changeTextAlignment(to: .center)
      .changeFontSize(to: subtitleLabelFontSize)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .change(height: subtitleLabelFontSize)
      .change(width: view.bounds.width)
      .move(48, pointBelow: videoPreviewView)
      .centerX(inside: view)
      .anchor(to: view)
    
    let detailSubtitleLabelFontSize = 16.cgFloat
    detailSubtitleLabel = UILabel()
      .changeTextAlignment(to: .center)
      .changeFontSize(to: detailSubtitleLabelFontSize)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .change(height: detailSubtitleLabelFontSize)
      .change(width: view.bounds.width)
      .move(16, pointBelow: subtitleLabel)
      .centerX(inside: view)
      .anchor(to: view)
  }
  
  private func configureMeowImageView() {
    meowImageView = UIImageView()
      .change(height: 94)
      .change(width: 74)
      .centerX(inside: view)
      .move(-50, pointsBottomToAndInside: view)
      .anchor(to: view)
    meowImageView.contentMode = .scaleAspectFill
    meowImageView.image = #imageLiteral(resourceName: "meow_normal")
  }
  
  private func configureEmptyStateViews() {
    let left = 24.cgFloat
    emptyStateOpenCameraButton = UIButton(type: .system)
      .set(title: "開啟相機權限", titleColor: .white, backgroundColor: MeowInvoiceColor.mainOrange, highlightBackgroundColor: MeowInvoiceColor.mainOrange)
      .change(height: 40)
      .change(width: view.bounds.width - 2 * left)
      .centerX(inside: view)
      .centerY(inside: view)
      .anchor(to: view)
      .change(cornerRadius: 20)
      .clipedToBounds()
    emptyStateOpenCameraButton?.addTarget(self, action: #selector(InvoiceQRCodeScannerViewController.gotoAppSettingPage), for: .touchUpInside)
    
    emptyStateSubtitleLabel = UILabel()
      .changeTextAlignment(to: .center)
      .changeFontSize(to: 12)
      .changeTextColor(to: MeowInvoiceColor.textColor)
      .change(height: 12)
      .change(width: emptyStateOpenCameraButton!.bounds.width)
      .move(24, pointTopOf: emptyStateOpenCameraButton!)
      .centerX(to: emptyStateOpenCameraButton!)
      .anchor(to: view)
    emptyStateSubtitleLabel?.text = "開啟相機功能，才可以掃描對發票喔！"
    
    emptyStateTitleLabel = UILabel()
      .changeTextAlignment(to: .center)
      .changeFontSize(to: 32)
      .changeTextColor(to: MeowInvoiceColor.darkTextColor)
      .change(height: 32)
      .change(width: emptyStateSubtitleLabel!.bounds.width)
      .move(16, pointTopOf: emptyStateSubtitleLabel!)
      .centerX(to: emptyStateSubtitleLabel!)
      .anchor(to: view)
    emptyStateTitleLabel?.text = "使用相機掃描"
  }
  
  @objc private func gotoAppSettingPage() {
    presenter?.gotoAppSettingsPage()
  }
  
  // MARK: - InvoiceQRCodeScannerView
  public func displayScanResult(_ viewModel: InvoiceQRCodeScanResultViewModel) {
    resultLabel.text = viewModel.result
    detailResultLabel.text = viewModel.detailResult
    subtitleLabel.text = viewModel.subtitle
    detailSubtitleLabel.text = viewModel.detailSubtitle
    meowImageView.image = viewModel.shouldMeowCry ? #imageLiteral(resourceName: "meow_cry") : #imageLiteral(resourceName: "meow_normal")
    
    if viewModel.play.win {
      MeowSound.play().winning()
    } else if viewModel.play.fail {
      MeowSound.play().fail()
    } else if viewModel.play.error {
      MeowSound.play().error()
    }
  }
  
}

extension InvoiceQRCodeScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
  
  public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
    // Check if the metadataObjects array is not nil and it contains at least one object.
    guard let metadataObjects = metadataObjects else {
      [qrCodeFrameViews.first, qrCodeFrameViews.second].forEach { $0.frame = CGRect.zero }
      return
    }
    
    // initial state.
    [qrCodeFrameViews.first, qrCodeFrameViews.second].forEach { $0.frame = CGRect.zero }
    
    var qrCodes: [String] = []
    
    if let firstMetaObject = metadataObjects[safe: 0] as? AVMetadataMachineReadableCodeObject {
      if supportedBarCodes.contains(firstMetaObject.type) {
        if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: firstMetaObject) {
          qrCodeFrameViews.first.frame = barCodeObject.bounds
          let qrcode = firstMetaObject.stringValue ?? ""
          qrCodes.append(qrcode)
        }
      }
    }
    
    if let secondMetaObject = metadataObjects[safe: 1] as? AVMetadataMachineReadableCodeObject {
      if supportedBarCodes.contains(secondMetaObject.type) {
        if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: secondMetaObject) {
          qrCodeFrameViews.second.frame = barCodeObject.bounds
          let qrcode = secondMetaObject.stringValue ?? ""
          qrCodes.append(qrcode)
        }
      }
    }
    
    presenter?.presentResult(with: qrCodes)
  }
  
}
