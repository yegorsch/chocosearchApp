//
//  LoginViewController.swift
//  chocolife
//
//  Created by Егор on 9/15/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  private let categoriesSegueIdentifier = "showCategories"
  private let placesSegueIdentifier = "showOptions1"

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func authenticateButtonPressed(_ sender: CommonButton) {
    self.presentActivityIndicator()
    let userLocal = UserLocal(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    NetworkingManager.shared.signUpUser(user: userLocal, successBlock: { (user) in
      self.removeActivityIndicator()
      self.performSegue(withIdentifier: "showOptions", sender: userLocal)
      // Adding to database
      NetworkingManager.shared.update(user: userLocal)
    }, errorBlock: { (error) in
      self.removeActivityIndicator()
      guard let errorRecieved = AuthErrorCode(rawValue: error._code) else {
        AlertManager.showErrorAlert()
        return
      }
      if errorRecieved.rawValue == AuthErrorCode.emailAlreadyInUse.rawValue {
        NetworkingManager.shared.signIn(userLocal: userLocal, successBlock: { user in
          self.performSegue(withIdentifier: "showOptions", sender: userLocal)
        }, errorBlock: { error in
          AlertManager.showErrorAlert(error.localizedDescription, action: nil)
        })
      } else {
        AlertManager.showErrorAlert(error.localizedDescription, action: nil)
      }
    })
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc2 = segue.destination as? OptionsViewController, let user = sender as? UserLocal {
      vc2.user = user
    }
  }

}
