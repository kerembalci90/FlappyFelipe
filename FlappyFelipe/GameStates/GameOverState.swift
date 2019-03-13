//
//  GameOverState.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-10.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    unowned var scene: GameScene
    let hitGroundAction: SKAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let animationDelay = 0.3
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.run(hitGroundAction)
        scene.stopSpawning()
        scene.player.movementAllowed = false
        showScoreCard()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
    
    func setBestScore(_ bestScore: Int) {
        UserDefaults.standard.set(bestScore, forKey: "BestScore")
        UserDefaults.standard.synchronize()
    }
    
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: "BestScore")
    }
    
    func showScoreCard() {
        if scene.score > getBestScore() {
            setBestScore(scene.score)
        }
        
        let scorecard = SKSpriteNode(imageNamed: "ScoreCard")
//        scorecard.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scorecard.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(scorecard)
        
        let lastScore = SKLabelNode(fontNamed: scene.fontName)
        lastScore.position = CGPoint(x: -scorecard.size.width * 0.25, y: -scorecard.size.height * 0.2)
        lastScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        lastScore.zPosition = Layer.ui.rawValue
        lastScore.text = "\(scene.score / 2)"
        scorecard.addChild(lastScore)
        
        let bestScore = SKLabelNode(fontNamed: scene.fontName)
        bestScore.position = CGPoint(x: scorecard.size.width * 0.25, y: -scorecard.size.height * 0.2)
        bestScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        bestScore.zPosition = Layer.ui.rawValue
        bestScore.text = "\(getBestScore() / 2)"
        scorecard.addChild(bestScore)
        
        let gameOverImage = SKSpriteNode(imageNamed: "GameOver")
        gameOverImage.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + scorecard.size.height / 2 + scene.margin + gameOverImage.size.height / 2)
        gameOverImage.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(gameOverImage)
        
        let okButton = SKSpriteNode(imageNamed: "Button")
        okButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height / 2 - scorecard.size.height / 2 - scene.margin - gameOverImage.size.height / 2)
        okButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(okButton)
        
        let okText = SKSpriteNode(imageNamed: "OK")
        okText.position = CGPoint.zero
        okText.zPosition = Layer.ui.rawValue
        okButton.addChild(okText)
        
        let shareButton = SKSpriteNode(imageNamed: "Button")
        shareButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height / 2 - scorecard.size.height / 2 - scene.margin - gameOverImage.size.height / 2)
        shareButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(shareButton)
        
        let shareText = SKSpriteNode(imageNamed: "Share")
        shareText.position = CGPoint.zero
        shareText.zPosition = Layer.ui.rawValue
        shareButton.addChild(shareText)
        
        gameOverImage.setScale(0)
        gameOverImage.alpha = 0
        let group = SKAction.group([
            SKAction.fadeIn(withDuration: animationDelay),
            SKAction.scale(to: 1.0, duration: animationDelay)
        ])
        group.timingMode = .easeInEaseOut
        gameOverImage.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            group
        ]))
        
        scorecard.position = CGPoint(x: scene.size.width * 0.5, y: -scorecard.size.height / 2)
        let moveTo = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2), duration: animationDelay)
        moveTo.timingMode = .easeInEaseOut
        scorecard.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 2),
            moveTo
        ]))
        
        okButton.alpha = 0
        shareButton.alpha = 0
        let fadeIn = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 3),
            SKAction.fadeIn(withDuration: animationDelay)
        ])
        okButton.run(fadeIn)
        shareButton.run(fadeIn)
        
        let pops = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            scene.popSoundAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popSoundAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popSoundAction
        ])
        scene.run(pops)
    }
}
