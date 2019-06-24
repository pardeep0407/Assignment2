//
//  GameViewController.swift
//  ColorGalaga
//
//  Created by Pardeep on 10/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegates {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSceneView()
    }

    override var shouldAutorotate: Bool {
        return true
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
    
    
    //MARK: - Setups
    func setupSceneView(){
       
        // initialize the initial game scene
        let GScene = GameScene(size:view.frame.size)
        GScene.gameScenedelegate = self
        let skView = view as! SKView
        
        // add some debug info to the screen
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // additional configuration options
        
        
        // show the scene
        skView.presentScene(GScene)
    }
    
    //MARK: -
    func didLoose() {
        
    }
    
    func didWin() {
        
    }
}
