//
//  GameOverScene.swift
//  ColorGalaga
//
//  Created by Pardeep on 10/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene:SKScene {
    
    override init(size: CGSize) {
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let bgNode = SKSpriteNode(imageNamed: "YouLose")
        bgNode.position = CGPoint(x:self.size.width/2,
                                  y:self.size.height/2)
        bgNode.zPosition = -1
        addChild(bgNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gameScene = GameScene(size: self.size)
        
        gameScene.scaleMode = self.scaleMode
        let transitionEffect = SKTransition.fade(withDuration: 2)
        self.view?.presentScene(gameScene, transition: transitionEffect)
    }
}
