//
//  ViewControllera+Additions.swift
//  chocolife
//
//  Created by Егор on 9/16/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentActivityIndicator() {
    let frame = CGRect(x: self.view.frame.midX - 30, y: self.view.frame.midY - 60, width: 60, height: 60)
    let indicator = UIActivityIndicatorView(frame: frame)
    indicator.activityIndicatorViewStyle = .gray
    self.view.addSubview(indicator)
    indicator.startAnimating()
  }

  func removeActivityIndicator() {
    for view in self.view.subviews {
      if view.classForCoder == UIActivityIndicatorView.classForCoder() {
        view.removeFromSuperview()
      }
    }
  }
}
