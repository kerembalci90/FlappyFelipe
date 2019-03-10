//
//  FallingState.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-10.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class FallingState: GKState {
    unowned var scene: GameScene
    let whackAction: SKAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let fallingAction: SKAction = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.run(SKAction.sequence([whackAction, SKAction.wait(forDuration: 0.1), fallingAction]))
        scene.stopSpawning()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
}
