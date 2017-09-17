//
//  NetworkingManager.swift
//  chocolife
//
//  Created by Егор on 9/16/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import FirebaseAuth

class NetworkingManager {

  static let shared = NetworkingManager()

  typealias SuccessBlock = (User) -> ()
  typealias ErrorBlock = (Error) -> ()

  private let ip = "http://0.0.0.0:8080"
  private let userPath = "/user"
  private var userURL: URLConvertible {
    let url = ip + userPath
    return URL(string: url)!
  }

  private init() { }

  func signIn(userLocal: UserLocal, successBlock: @escaping SuccessBlock, errorBlock: @escaping ErrorBlock) {
    Auth.auth().signIn(withEmail: userLocal.email, password: userLocal.password, completion: { (user, error) in
      if let error = error {
        errorBlock(error)
        return
      }
      successBlock(user!)
    })
  }

  func signUpUser(user: UserLocal, successBlock: @escaping SuccessBlock, errorBlock: @escaping ErrorBlock) {
    Auth.auth().createUser(withEmail: user.email, password: user.password, completion: { (user, error) in
      if let errorRecieved = error {
        errorBlock(errorRecieved)
        return
      }
      successBlock(user!)
    })
  }

  func update(user: UserLocal) {
    Alamofire.request(userURL, method: .post, parameters: user.toParams(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {response in
      let error = response.error
      print(error?.localizedDescription)
    })
  }


}
