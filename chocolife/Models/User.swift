//
//  User.swift
//  chocolife
//
//  Created by Егор on 9/16/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

protocol ParameterConvertible {
  func toParams() -> [String: Any]
}

class UserLocal: ParameterConvertible {

  var email: String
  var password: String
  var location: String = "0.0,0.0"
  var subscribed: Bool = true
  var radius: Double = 1000
  var categories: [String]!

  init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  func toParams() -> [String: Any] {
    var sub = "false"
    if subscribed {
      sub = "true"
    }
    return ["email": email, "lastLocation": location, "subscribed": sub, "radius": radius]
  }


}
