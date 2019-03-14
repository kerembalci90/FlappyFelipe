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
    var animationComponent: AnimationComponent!
    
    var movementAllowed = false
    var numberOfFrames = 3
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        movementComponent = MovementComponent(entity: self)
        addComponent(movementComponent)
        
        setupAnimationComponent()
        setupPhyicsBody()
    }
    
    private func setupAnimationComponent() {
        var textures: Array<SKTexture> = []
        for i in 0..<numberOfFrames {
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        for i in stride(from: numberOfFrames, through: 0, by: -1) {
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        animationComponent = AnimationComponent(entity: self, textures: textures)
        addComponent(animationComponent)
    }
    
    private func setupPhyicsBody() {
        spriteComponent.node.physicsBody = SKPhysicsBody(texture: spriteComponent.node.texture!, size: spriteComponent.node.frame.size)
        spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteComponent.node.physicsBody?.collisionBitMask = 0
        spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
