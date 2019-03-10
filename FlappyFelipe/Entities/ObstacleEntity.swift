//
//  ObstacleEntity.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-08.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObstacleEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        setupPhysicsBody()
    }
    
    fileprivate func setupPhysicsBody() {
        spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
        spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        spriteComponent.node.physicsBody?.collisionBitMask = 0
        spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
