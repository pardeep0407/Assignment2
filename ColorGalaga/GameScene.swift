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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let locationTouched = touches.first else {
            return
        }
        
        let mousePosition = locationTouched.location(in: self)
        let moveAction = SKAction.moveTo(x: mousePosition.x, duration: 0.5)
        spaceShip.run(moveAction)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let locationTouched = touches.first else {
            return
        }
        
        let mousePosition = locationTouched.location(in: self)
        let moveAction = SKAction.moveTo(x: mousePosition.x, duration: 0.2)
        spaceShip.run(moveAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func setupSpaceShip(){
        spaceShip = SKSpriteNode.init(texture: SKTexture(imageNamed: "playerShip3_orange.png"))
        spaceShip.size = CGSize.init(width: 50, height: 50)
        spaceShip.position = CGPoint.init(x: (screenSize.width/2), y: 80)
        addChild(spaceShip)
    }
}
