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
    
    // keep track of all the Node objects on the screen
    var bullets : [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        self.setupSpaceShip()
    }
    
    // variable to keep track of how much time has passed
    var timeOfLastUpdate:TimeInterval?
    
    override func update(_ currentTime: TimeInterval) {
        
        if (timeOfLastUpdate == nil) {
            timeOfLastUpdate = currentTime
        }
        
        let timePassed = (currentTime - timeOfLastUpdate!)
        if (timePassed >= 1) {
            timeOfLastUpdate = currentTime
            // create a bullet
            self.createBullet()
        }
        
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
    
    
    func createBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "fire07.png")
        
        // generate a location (x,y) for the bullet
        let bulletX = Int(CGFloat(spaceShip.position.x))
        let bulletY = Int(CGFloat(spaceShip.position.y))
        
        bullet.position = CGPoint(x:bulletX, y:bulletY)
        
        let bulletDestination = CGPoint(x: spaceShip.position.x, y: frame.size.height + bullet.frame.size.height / 2)
        
        self.fireBullet(bullet: bullet, toDestination: bulletDestination,withDuration: 1.0,andSoundFileName: "")
        
        // add the bullet to the cats array
        self.bullets.append(bullet)
        
    }
    
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
        let bulletAction = SKAction.sequence([SKAction.move(to: destination, duration: duration)])
        //, SKAction.wait(forDuration: 3.0 / 60.0),SKAction.removeFromParent()
        //let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        bullet.run(SKAction.group([bulletAction]))
        
        // add the bullet to the scene
        addChild(bullet)
    }
    
}
