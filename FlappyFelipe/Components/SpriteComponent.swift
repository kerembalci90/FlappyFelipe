//
//  SpriteComponent.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-04.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityNode: SKSpriteNode {
    
}

class SpriteComponent: GKComponent {
    var node: EntityNode
    
    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = EntityNode(texture: texture, color: SKColor.white, size: size)
        node.entity = entity
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
