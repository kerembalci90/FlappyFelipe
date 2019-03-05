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
    
    let gravity: CGFloat = -1500
    let impulse = 400
    var velocity = CGPoint.zero
    var groundYPosition: CGFloat = 0
    
    init(entity: GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyImpulse(_ lastUpdateTime: TimeInterval) {
        velocity = CGPoint(x: 0, y: impulse)
    }
    
    func applyMovement(timeElapsed: TimeInterval) {
        let spriteNode = spriteComponent.node
        
        // Apply Gravity
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(timeElapsed)
        velocity += gravityStep
        
        // Apply Velocity
        let velocityStep = velocity * CGFloat(timeElapsed)
        spriteNode.position += velocityStep
        
        // Temporary ground hit
        if spriteNode.position.y - spriteNode.size.height / 2 < groundYPosition {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: groundYPosition + spriteNode.size.height / 2)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            applyMovement(timeElapsed: seconds)
        }
    }
    
}
