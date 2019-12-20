//
//  GameViewController.swift
//  FallingBlock
//
//  Created by Hao Zhou on 19/12/19.
//  Copyright © 2019 Hao Zhou. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  @IBOutlet weak var skView: SKView!
  @IBOutlet weak var switchMode: UISwitch!
  
  var gameScene: GameScene!
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    gameScene = GameScene()
    gameScene.size = skView.bounds.size
    
    skView.presentScene(gameScene)
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  @IBAction func onStart(_ sender: Any) {
    gameScene.start(switchMode.isOn ? GameMode.block : GameMode.sheet)
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
