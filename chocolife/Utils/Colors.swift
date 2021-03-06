//
//  Colors.swift
//  chocolife
//
//  Created by Егор on 9/14/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
  static let categoryBallColor = UIColor(colorCode: "ed254e")
  static let subcategoryBallColor = UIColor(colorCode: "235789")
  static let buttonBackgroundColor = UIColor(colorCode: "ed254e")
  static let buttonTitleColor = UIColor(colorCode: "ffffff")
}

extension UIColor {
  convenience init(colorCode: String, alpha: Float = 1.0){
    let scanner = Scanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt32(&color)

    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)

    self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
  }
}
