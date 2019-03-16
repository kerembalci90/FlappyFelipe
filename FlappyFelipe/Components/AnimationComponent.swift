//
//  AnimationComponent.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-13.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    let spriteComponent: SpriteComponent
    var textures: Array<SKTexture> = []
    
    init(entity: GKEntity, textures: Array<SKTexture>) {
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            if player.movementAllowed {
                startAnimation()
            } else {
                stopAnimation("Flap")
            }
        }
    }
    
    func startWobble() {
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.4)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        let wobbleSequence = SKAction.sequence([moveUp, moveDown])
        let wobbleSequenceForever = SKAction.repeatForever(wobbleSequence)
        spriteComponent.node.run(wobbleSequenceForever, withKey: "Wobble")
        
        let flapWings = SKAction.animate(with: textures, timePerFrame: 0.07)
        let flapWingsForever = SKAction.repeatForever(flapWings)
        spriteComponent.node.run(flapWingsForever, withKey: "Wobble-Forever")
    }
    
    func stopWobble() {
        stopAnimation("Wobble")
        stopAnimation("Wobble-Forever")
    }
    
    func startAnimation() {
        if spriteComponent.node.action(forKey: "Flap") == nil {
            let flapAnimationAction = SKAction.animate(with: textures, timePerFrame: 0.07)
            let flapForeverSequence = SKAction.repeatForever(flapAnimationAction)
            spriteComponent.node.run(flapForeverSequence, withKey: "Flap")
        }
    }
    
    func stopAnimation(_ name: String) {
        spriteComponent.node.removeAction(forKey: name)
    }
}
