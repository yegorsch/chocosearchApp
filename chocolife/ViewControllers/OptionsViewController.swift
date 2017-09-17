//
//  OptionsViewController.swift
//  chocolife
//
//  Created by Егор on 9/17/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OptionsViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var radiusSlider: UISlider!
  @IBOutlet weak var radiusLabel: UILabel!

  var user: UserLocal!
  let locationManager = CLLocationManager()

  var radius: Float = 100 {
    didSet {
      if radius == 10000 {
        radiusLabel.text = "All"
      } else {
        radiusLabel.text = "\(Int(radius)) meters"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.radiusSlider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
    setupLocationServices()
  }

  @IBAction func chooseCategoriesPressed(_ sender: CommonButton) {
    let vc = ViewController()
    vc.user = self.user
    vc.directionToGo = .back
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func sliderValueDidChange(sender: UISlider!) {
    let newVal = Float(Int(sender.value / 100.0) * 100)
    self.radius = newVal
    self.user.radius = Double(newVal)
    sender.setValue(newVal, animated: false)
  }

  @IBAction func switched(_ sender: UISwitch) {
    self.user.subscribed = sender.isOn
  }
  @IBAction func updateUser(_ sender: CommonButton) {
    NetworkingManager.shared.update(user: self.user)
    AlertManager.showOkAlert("Updated", message: "Information has been updated")
  }

  private func setupLocationServices() {
    // Ask for Authorisation from the User.
    self.locationManager.requestAlwaysAuthorization()

    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = manager.location else {
      return
    }
    self.user.location = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
    NetworkingManager.shared.update(user: user)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }

}
