//
//  CategoriesScene.swift
//  chocolife
//
//  Created by Егор on 9/11/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class CategoriesScene: SKScene {

  fileprivate var categoryBalls = [SKShapeNode]()
  fileprivate var subcategoryBalls = [SKShapeNode]()
  fileprivate var ballPositionDictionary = [String: CGPoint]()
  private let fontName = UIFont.boldSystemFont(ofSize: 25).fontName

  fileprivate var motionManager = CMMotionManager()
  fileprivate var destX: CGFloat = 0.0
  fileprivate var destY: CGFloat = 0.0

  var categories = [String]()

  struct Actions {
    static var blowUp: SKAction {
      let fadeoutAction = SKAction.fadeOut(withDuration: 0.1)
      let scaleAction = SKAction.scale(to: 2.0, duration: 0.1)
      return SKAction.group([scaleAction, fadeoutAction])
    }
    static var shrink: SKAction {
      let fadeoutAction = SKAction.fadeOut(withDuration: 0.1)
      let scaleAction = SKAction.scale(to: 0.1, duration: 0.1)
      return SKAction.group([scaleAction, fadeoutAction])
    }
  }

  private var randomX: CGFloat {
    get {
      return self.frame.minX + CGFloat(arc4random_uniform(UInt32(self.frame.maxX * 2)))
    }
  }

  private var randomY: CGFloat {
    get {
      return CGFloat(arc4random_uniform(UInt32(self.frame.maxY)))
    }
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    addCategoryBalls()
    createFloor()
    setupMotionDetector()
  }

  private func createFloor() {
    let floor = SKSpriteNode(color: SKColor.brown, size: CGSize(width: self.frame.width, height: 20))

    floor.anchorPoint = CGPoint(x: self.frame.minX, y: self.frame.minY)
    floor.name = "floor"
    floor.physicsBody = SKPhysicsBody(edgeLoopFrom: floor.frame)
    floor.physicsBody?.isDynamic = false

    self.addChild(floor)
  }

  private func createBall(position: CGPoint, with name: String, for type: CategoryTypes) {
    let ball: SKShapeNode
    let label: SKLabelNode
    switch type {
    case .category:
      label = SKLabelNode(text: name)
      label.fontSize = 18
      label.fontName = self.fontName
      ball = SKShapeNode(circleOfRadius: label.frame.width / 2 + 10)
      ball.fillColor = Colors.categoryBallColor
      ball.physicsBody?.affectedByGravity = false
      self.categoryBalls.append(ball)
    case .subcategory:
      label = SKLabelNode(text: name)
      label.fontSize = 12
      label.fontName = self.fontName
      ball = SKShapeNode(circleOfRadius: label.frame.width / 2 + 10)
      ball.fillColor = Colors.subcategoryBallColor
      self.subcategoryBalls.append(ball)
    }

    ball.position = position
    ball.name = name

    ball.physicsBody = SKPhysicsBody(circleOfRadius: label.frame.width / 2 + 10)
    ball.physicsBody?.isDynamic = true
    ball.physicsBody?.restitution = 0.5
    ball.physicsBody?.allowsRotation = false
    ball.physicsBody?.collisionBitMask = 1

    ball.addChild(label)
    self.addChild(ball)
  }

  private func addCategoryBalls() {
    for item in Categories.all {
      let centerPoint = CGPoint(x: self.randomX, y: self.randomY)
      self.createBall(position: centerPoint, with: item.name, for: .category)
    }
  }

  private func handleCategoryBalls(_ location: CGPoint) {
    for ball in self.categoryBalls {
      if ball.frame.contains(location) {
        guard let subcategories = CategoriesManager.shared.subcategories(for: ball.name!) else {
          return
        }
        ball.run(Actions.blowUp, completion: {
          ball.removeFromParent()
          for category in subcategories {
            let centerPoint = CGPoint(x: self.randomX, y: ball.position.y)
            self.createBall(position: centerPoint, with: category, for: .subcategory)
          }
        })
      }
    }
  }

  private func handleSubcategoryBalls(_ location: CGPoint) {
    for ball in self.subcategoryBalls {
      if ball.frame.contains(location) {
        ball.physicsBody?.collisionBitMask = 0
        ball.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.maxY + 2 * ball.frame.height), duration: 0.6), completion: {
          ball.removeFromParent()
          self.categories.append(ball.name!)
        })
      }
    }
  }

  func resetScene() {
    for ball in self.categoryBalls {
      ball.removeFromParent()
    }
    for ball in self.subcategoryBalls {
      ball.removeFromParent()
    }
    addCategoryBalls()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      handleCategoryBalls(location)
      handleSubcategoryBalls(location)
    }
  }
  override func update(_ currentTime: TimeInterval) {
    updateGravity()
  }


}

extension CategoriesScene {

  fileprivate func setupMotionDetector() {
    if motionManager.isAccelerometerAvailable == true {
      motionManager.startAccelerometerUpdates()
    }
  }

  fileprivate func updateGravity() {
    if let accelerometerData = motionManager.accelerometerData {
      physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 5, dy: accelerometerData.acceleration.y * 5)
    }
  }
  
}

