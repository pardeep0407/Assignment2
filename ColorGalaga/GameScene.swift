//
//  GameScene.swift
//  ColorGalaga
//
//  Created by Som on 10/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let screenSize = UIScreen.main.bounds.size
    var spaceShip = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.setupSpaceShip()
    }
    
    func setupSpaceShip(){
        spaceShip = SKSpriteNode.init(texture: SKTexture(imageNamed: "playerShip3_orange.png"))
        spaceShip.size = CGSize.init(width: 50, height: 50)
        spaceShip.position = CGPoint.init(x: (screenSize.width/2), y: 80)
        addChild(spaceShip)
    }
}
