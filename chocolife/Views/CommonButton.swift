//
//  CommonButton.swift
//  chocolife
//
//  Created by Егор on 9/15/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

class CommonButton: UIButton {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    self.backgroundColor = Colors.buttonBackgroundColor
    self.setTitleColor(Colors.buttonTitleColor, for: .normal)
    self.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
    setupBorder()
  }

  private func setupBorder() {
    self.layer.cornerRadius = 5.0
    self.layer.borderColor = Colors.buttonBackgroundColor.cgColor
  }

}
