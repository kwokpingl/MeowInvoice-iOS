//
//  ViewController.swift
//  MeowInvoice
//
//  Created by David on 2017/5/29.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var bar: MeowNavigationBar!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    bar = MeowNavigationBar(width: view.bounds.width)
    bar.anchor(to: view)
    
    
    
    FetchInvoiceAwards().makeRequest().then(execute: { (this, previous) -> Void in
      print(this, previous)
    })
    .catch(execute: { e in
      print(e)
    })
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

