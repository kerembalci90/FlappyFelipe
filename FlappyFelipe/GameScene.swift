//
//  GameScene.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-03.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Layer: CGFloat {
    case background
    case foreground
}

class GameScene: SKScene {
    
    let worldNode = SKNode()
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 0
    
    let numberOfForegrounds = 3
    let groundSpeed: CGFloat = 150
    var deltaTime: TimeInterval = 0;
    var lastUpdateTimeInterval : TimeInterval = 0;
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupForeground()
        addChild(worldNode)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "Background")
        
        background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background.position = CGPoint(x: size.width / 2, y: size.height)
        background.zPosition = Layer.background.rawValue
        worldNode.addChild(background)
        
        playableStart = size.height - background.size.height;
        playableHeight = background.size.height
    }
    
    func setupForeground() {
        
        for i in 0..<numberOfForegrounds {
            let foreground = SKSpriteNode(imageNamed: "Ground")
            foreground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            foreground.position = CGPoint(x: CGFloat(i) * foreground.size.width, y: playableStart)
            foreground.zPosition = Layer.foreground.rawValue
            foreground.name = "Foreground"
            
            worldNode.addChild(foreground)
        }
    }
    
    /**
     * Responsible for moving the foreground tiles from out of screen on the left to the start of the queue
     * on the right of the screen.
     */
    func updateForeground() {
        worldNode.enumerateChildNodes(withName: "Foreground") { (node, stop) in
            if let foreground = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y: 0)
                foreground.position += moveAmount
                
                if foreground.position.x < -foreground.size.width {
                    foreground.position += CGPoint(x: foreground.size.width * CGFloat(self.numberOfForegrounds), y: 0)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        updateForeground()
    }
}
