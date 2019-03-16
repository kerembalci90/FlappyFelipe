//
//  GameViewController.swift
//  FlappyFelipeTV
//
//  Created by Kerem BALCI on 2019-03-16.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                let scene = GameScene(size: CGSize(width: 568 / aspectRatio, height: 568), stateClass: MainMenuState.self, delegate: self)
                
                skView.showsFPS = false
                skView.showsNodeCount = false
                skView.showsPhysics = false
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFit
                
                skView.presentScene(scene)
            }
        }
    }
    
    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func shareString(_ string: String, url: URL, image: UIImage) {
        // No implementation for Apple TV
    }
    
}
