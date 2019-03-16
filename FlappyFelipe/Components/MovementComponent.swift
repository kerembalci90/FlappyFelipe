//
//  MovementComponent.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-04.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    var spriteComponent: SpriteComponent
    
    let flapSoundAction = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    
    let gravity: CGFloat = -1500
    let impulse = 400
    var velocity = CGPoint.zero
    var groundYPosition: CGFloat = 0
    
    var velocityModifier: CGFloat = 1000.0
    var angularVelocity: CGFloat = 0.0
    let minDegrees: CGFloat = -90
    let maxDegrees: CGFloat = 25
    
    var lastTouchTime: TimeInterval = 0
    var lastTouchY: CGFloat = 0.0
    
    init(entity: GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyInitialImpulse() {
        velocity = CGPoint(x: 0, y: impulse * 2)
        spriteComponent.node.run(flapSoundAction)
    }
    
    func applyImpulse(_ lastUpdateTime: TimeInterval) {
        velocity = CGPoint(x: 0, y: impulse)
        
        angularVelocity = velocityModifier.degreesToRadians()
        lastTouchTime = lastUpdateTime
        lastTouchY = spriteComponent.node.position.y
        
        spriteComponent.node.run(flapSoundAction)
    }
    
    func applyMovement(timeElapsed: TimeInterval) {
        let spriteNode = spriteComponent.node
        
        // Apply Gravity
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(timeElapsed)
        velocity += gravityStep
        
        // Apply Velocity
        let velocityStep = velocity * CGFloat(timeElapsed)
        spriteNode.position += velocityStep
        
        // Apply angular velocity and rotation
        if spriteNode.position.y < lastTouchY {
            angularVelocity = -velocityModifier.degreesToRadians()
        }
        
        let angularStep = angularVelocity * CGFloat(timeElapsed)
        spriteNode.zRotation += angularStep
        spriteNode.zRotation = min(max(spriteNode.zRotation, minDegrees.degreesToRadians()), maxDegrees.degreesToRadians())
        
        // Temporary ground hit
        if spriteNode.position.y - spriteNode.size.height / 2 < groundYPosition {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: groundYPosition + spriteNode.size.height / 2)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            if player.movementAllowed {
                applyMovement(timeElapsed: seconds)
            }
        }
    }
    
}
