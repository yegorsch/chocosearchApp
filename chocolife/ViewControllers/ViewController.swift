//
//  ViewController.swift
//  chocolife
//
//  Created by Егор on 9/11/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {

  private var sceneView: SKView!
  var directionToGo = Direction.back

  var user: UserLocal!

  enum Direction {
    case forward
    case back
  }

  convenience init(user: UserLocal) {
    self.init(nibName: nil, bundle: nil)
    self.user = user
  }

  var sceneFrame: CGRect {
    let height = UIApplication.shared.statusBarFrame.height +
      self.navigationController!.navigationBar.frame.height
    return CGRect(origin: CGPoint(x: 0, y: height), size: CGSize(width: self.view.frame.width, height: self.view.bounds.height - height))
  }

  @IBOutlet weak var resetButton: UIBarButtonItem!
  override func viewDidLoad() {
    super.viewDidLoad()
    presentInitialCategoriesPicker()
    let leftBarItem = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(resetScene(_:)))
    leftBarItem.tintColor = UIColor.red
    self.navigationItem.leftBarButtonItem = leftBarItem
    let rightBarItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(categoriesChosen))
    self.navigationItem.rightBarButtonItem = rightBarItem
  }

  private func presentInitialCategoriesPicker() {
    self.sceneView = SKView(frame: self.sceneFrame)
    self.view.addSubview(sceneView)
    // Load the SKScene from 'GameScene.sks'
    if let scene = SKScene(fileNamed: "CategoriesScene") {
      // Set the scale mode to scale to fit the window
      scene.scaleMode = .resizeFill
      // Present the scene
      sceneView.presentScene(scene)
    }
  }

  @objc func resetScene(_ sender: UIButton) {
    if let scene = self.sceneView.scene as? CategoriesScene {
      scene.resetScene()
    }
  }

  @objc private func categoriesChosen() {
    if let scene = self.sceneView.scene as? CategoriesScene {
      self.user.categories = scene.categories
      done()
    }
  }

  @objc private func done() {
    if let scene = self.sceneView.scene as? CategoriesScene {
      self.user.categories = scene.categories
      switch self.directionToGo {
      case .back:
        if let vc = self.navigationController?.popViewController(animated: true) as? OptionsViewController {
          vc.user = self.user
        }
      case .forward:
        performSegue(withIdentifier: "show", sender: self.user)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? OptionsViewController, let user = sender as? UserLocal {
      vc.user = user
    }
  }

}

