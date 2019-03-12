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
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.run(hitGroundAction)
        scene.stopSpawning()
        scene.player.movementAllowed = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
}
