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
    var enemies : [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        
        //self.setupBackground()
        self.setupSpaceShip()
        self.setupEnemies()
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
            self.moveEnemy()
        }
        
        
        self.detectCollision()
        
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
    
    func setupBackground(){
        let background = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "darkPurple.png"))
        background.size = screenSize
        //background.scaleMode = .AspectFill
        background.position = CGPoint.init(x: 0, y: 0)
        addChild(background)
    }
    
    func setupSpaceShip(){
        spaceShip = SKSpriteNode.init(texture: SKTexture(imageNamed: "playerShip3_orange.png"))
        spaceShip.size = CGSize.init(width: 50, height: 50)
        spaceShip.position = CGPoint.init(x: (screenSize.width/2), y: 80)
        addChild(spaceShip)
    }
    
    func setupEnemies(){
        
        let eCount : Int = 15
        let space : CGFloat = 30.0
        let height : CGFloat = 40.0
        let width : CGFloat = 40.0
        
        var xPosition : CGFloat = width + space
        var yPosition : CGFloat = screenSize.height - (height + space)
        
        
        for eIndex in 0...eCount {
            print(eIndex)
            
            let enemy = SKSpriteNode.init(texture: SKTexture(imageNamed: self.getEnemyImageName()))
            enemy.size = CGSize.init(width: width, height: height)
            enemy.zPosition = 1
            enemy.position = CGPoint.init(x: xPosition, y: yPosition)
            addChild(enemy)
            enemies.append(enemy)
            
            xPosition += space + width
            if xPosition >= screenSize.width - space{
                yPosition -= height + space
                xPosition = width + space
            }
        }
    }
    
    func getEnemyImageName() -> String{
        let enemyImageIndex = Int(CGFloat(arc4random_uniform(UInt32(3))))
        
        switch enemyImageIndex {
        case 0:
            return "enemyRed.png"
        case 1:
            return "enemyGreen.png"
        case 2:
            return "enemyBlue.png"
        default:
            return "enemyRed.png"
        }
        
    }
    
    func createBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "fire07.png")
        
        // generate a location (x,y) for the bullet
        let bulletX = Int(CGFloat(spaceShip.position.x))
        let bulletY = Int(CGFloat(spaceShip.position.y))
        
        bullet.position = CGPoint(x:bulletX, y:bulletY)
        
        let bulletDestination = CGPoint(x: spaceShip.position.x, y: frame.size.height + bullet.frame.size.height / 2)
        
        //addChild(bullet)
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
    
    func moveEnemy(){
        if self.enemies.count > 0{
            let enemyIndex = Int(CGFloat(arc4random_uniform(UInt32(self.enemies.count))))
            let enemyDestination = CGPoint(x: spaceShip.position.x, y: 0.0)
            let enemyAction = SKAction.move(to: enemyDestination, duration: 1.0)
            self.enemies[enemyIndex].run(enemyAction)
        }
    }
    
    func detectCollision(){
        
            for (enemyIndex, enemy) in enemies.enumerated() {
            
                for (arrayIndex, bullet) in bullets.enumerated() {
                    
                    if bullet.intersects(enemy){
                        
                        enemy.removeFromParent()
                        self.enemies.remove(at: enemyIndex)
                        
                        bullet.removeFromParent()
                        self.bullets.remove(at: arrayIndex)
                        
                    }
                    
                    if (bullet.position.y >= self.size.height)  {
                        //top of screen
                        bullet.removeFromParent()
                        self.bullets.remove(at: arrayIndex)
                    }
                    
                }
                
                
                if enemy.intersects(spaceShip){
                    enemy.removeFromParent()
                    self.enemies.remove(at: enemyIndex)
                }
                
                if (enemy.position.y <= 0.0)  {
                    //Bottom of screen
                    enemy.removeFromParent()
                    self.enemies.remove(at: enemyIndex)
                }
                
            }
            
        
    }
}
