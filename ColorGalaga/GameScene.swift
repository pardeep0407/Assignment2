//
//  GameScene.swift
//  ColorGalaga
//
//  Created by Pardeep on 10/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegates{
    func didLoose()
    func didWin()
}

class GameScene: SKScene {
    
    var gameScenedelegate : GameSceneDelegates?
    
    let screenSize = UIScreen.main.bounds.size
    var spaceShip = SKSpriteNode()
    
    // keep track of all the Node objects on the screen
    var bullets : [SKSpriteNode] = []
    var enemies : [SKSpriteNode] = []
    
    var lifes : [SKSpriteNode] = []
    var numberOfLifes : Int = 3
    var running = false
    
    override func didMove(to view: SKView) {
        
        self.setupBackground()
        self.setupLifes()
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
        background.position = CGPoint(x:self.size.width/2,
                                  y:self.size.height/2)
        background.zPosition = -1
        addChild(background)
    }
    
    func setupSpaceShip(){
        spaceShip = SKSpriteNode.init(texture: SKTexture(imageNamed: "playerShip3_orange.png"))
        spaceShip.size = CGSize.init(width: 50, height: 50)
        spaceShip.position = CGPoint.init(x: (screenSize.width/2), y: 80)
        addChild(spaceShip)
    }
    
    func setupLifes(){
        
        var __x : CGFloat = 40.0
        let space : CGFloat = 5.0
        
        for _ in 0..<numberOfLifes{
            let lifeSpaceShip = SKSpriteNode.init(texture: SKTexture(imageNamed: "playerShip3_orange.png"))
            lifeSpaceShip.size = CGSize.init(width: 30, height: 30)
            lifeSpaceShip.position = CGPoint.init(x: __x, y: 35.0)
            addChild(lifeSpaceShip)
            self.lifes.append(lifeSpaceShip)
            __x += 30.0 + space
        }
    }
    
    func setupEnemies(){
        
        let eCount : Int = 15
        let space : CGFloat = 30.0
        let height : CGFloat = 35.0
        let width : CGFloat = 35.0
        
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
    
    func createDamageAtLocation(location: CGPoint){
        
        var damageTexture : [SKTexture] = []
        damageTexture.append(SKTexture.init(imageNamed: "playerShip3_damage3.png"))
        damageTexture.append(SKTexture.init(imageNamed: "playerShip2_damage3.png"))
        damageTexture.append(SKTexture.init(imageNamed: "playerShip1_damage3.png"))
        
        damageTexture.append(SKTexture.init(imageNamed: "playerShip3_damage2.png"))
        damageTexture.append(SKTexture.init(imageNamed: "playerShip2_damage2.png"))
        damageTexture.append(SKTexture.init(imageNamed: "playerShip1_damage2.png"))
        
        damageTexture.append(SKTexture.init(imageNamed: "playerShip3_damage3.png"))
        damageTexture.append(SKTexture.init(imageNamed: "playerShip2_damage2.png"))
        damageTexture.append(SKTexture.init(imageNamed: "playerShip1_damage1.png"))
        
        let damage = SKSpriteNode.init(imageNamed: "playerShip3_damage3.png")
        damage.run(SKAction.sequence([SKAction.animate(with: damageTexture, timePerFrame: 0.1),SKAction.removeFromParent()])) {
            
        }
        damage.position = location
        damage.size = CGSize.init(width: 30.0, height: 30.0)
        self.addChild(damage)
        
    }
    
    func detectCollision(){
        
        for (enemyIndex, enemy) in enemies.enumerated() {
            
            for (arrayIndex, bullet) in bullets.enumerated() {
                
                //Detect Bullet collide with enemy
                if bullet.intersects(enemy){
                    
                    
                    self.createDamageAtLocation(location: enemy.position)
                    enemy.removeFromParent()
                    self.enemies.remove(at: enemyIndex)
                    
                    bullet.removeFromParent()
                    self.bullets.remove(at: arrayIndex)
                    
                    if self.enemies.count == 0{
                        self.youWin()
                        return
                    }
                    
                }
                
                if (bullet.position.y >= self.size.height)  {
                    //top of screen
                    bullet.removeFromParent()
                    self.bullets.remove(at: arrayIndex)
                }
                
            }
            
            
            //Detect enemy colide with spaceship
            if enemy.intersects(spaceShip){
                
                if running == false {
                    if lifes.count > 0{
                        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 0.4)
                        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.4)
                        
                        running = true
                        self.lifes.last?.removeFromParent()
                        self.lifes.removeLast()
                        
                        if self.lifes.count == 0{
                            self.spaceShip.removeFromParent()
                            self.createDamageAtLocation(location: spaceShip.position)
                            self.youLoose()
                        }else{
                            spaceShip.run(SKAction.sequence([fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn])) {
                                self.running = false
                            };
                        }
                        
                    }else{//Loose
                        self.youLoose()
                    }
                    
                    self.createDamageAtLocation(location: enemy.position)
                    enemy.removeFromParent()
                    self.enemies.remove(at: enemyIndex)
                    
                    if self.enemies.count == 0{
                        self.youWin()
                        return
                    }
                }
            }
            
            if (enemy.position.y <= 0.0)  {
                //Bottom of screen
                self.createDamageAtLocation(location: enemy.position)
                enemy.removeFromParent()
                self.enemies.remove(at: enemyIndex)
                
                if self.enemies.count == 0{
                    self.youWin()
                }
            }
            
        }
        
        
    }
    
    func youWin(){
        let winScene = WinScene(size: self.size)
        winScene.scaleMode = self.scaleMode
        let transitionEffect = SKTransition.fade(withDuration: 2)
        self.view?.presentScene(winScene, transition: transitionEffect)
    }
    
    func youLoose(){
        
        let loseScene = GameOverScene(size: self.size)
        loseScene.scaleMode = self.scaleMode
        let transitionEffect = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(loseScene, transition: transitionEffect)
    }
}
