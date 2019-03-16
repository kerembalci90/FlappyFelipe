//
//  GameScene+TV.swift
//  FlappyFelipeTV
//
//  Created by Kerem BALCI on 2019-03-16.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit

extension GameScene: TVControlScene {
    func setupTVControls() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameScene.didTapOnRemote(_:)))
        view!.addGestureRecognizer(tap)
    }
    
    @objc func didTapOnRemote(_ tap: UITapGestureRecognizer) {
        switch stateMachine.currentState {
        case is MainMenuState:
            restartGame(TutorialState.self)
        case is TutorialState:
            stateMachine.enter(PlayingState.self)
        case is PlayingState:
            player.movementComponent.applyImpulse(lastUpdateTimeInterval)
        case is GameOverState:
            restartGame(TutorialState.self)
        default:
            break
        }
    }
}
