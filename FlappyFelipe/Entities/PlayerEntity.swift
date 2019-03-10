//
//  PlayerEntity.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-04.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    var movementComponent: MovementComponent!
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        movementComponent = MovementComponent(entity: self)
        addComponent(movementComponent)
        
        setupPhyicsBody()
    }
    
    fileprivate func setupPhyicsBody() {
        spriteComponent.node.physicsBody = SKPhysicsBody(texture: spriteComponent.node.texture!, size: spriteComponent.node.frame.size)
        spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteComponent.node.physicsBody?.collisionBitMask = 0
        spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
