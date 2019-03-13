//
//  GameScene.swift
//  FlappyFelipe
//
//  Created by Kerem BALCI on 2019-03-03.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Layer: CGFloat {
    case background
    case obstacle
    case foreground
    case player
    case ui
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Obstacle: UInt32 = 0b10
    static let Ground: UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let worldNode = SKNode()
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 0
    let bottomObstacleMinFraction: CGFloat = 0.1
    let bottomObstacleMaxFraction: CGFloat = 0.6
    let gapMultiplier: CGFloat = 4.5 // Higher the number easier the game
    
    let numberOfForegrounds = 3
    let groundSpeed: CGFloat = 150
    var deltaTime: TimeInterval = 0;
    var lastUpdateTimeInterval : TimeInterval = 0;
    let firstObstacleSpawnDelay: TimeInterval = 1.75
    let eachObstacleSpawnDelay: TimeInterval = 1.5
    
    let player = PlayerEntity(imageName: "Bird0")
    let popSoundAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    
    var initalState: AnyClass
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        MainMenuState(scene: self),
        TutorialState(scene: self),
        PlayingState(scene: self),
        FallingState(scene: self),
        GameOverState(scene: self)
        ])
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var fontName: String = "AmericanTypewriter-Bold"
    var margin: CGFloat = 20.0
    let coinSoundAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    
    init(size: CGSize, stateClass: AnyClass) {
        initalState = stateClass
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupWorldPhyics()
        addChild(worldNode)
        stateMachine.enter(initalState)
    }
    
    func setupWorldPhyics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func setupPlayer() {
        player.spriteComponent.node.position = CGPoint(x: size.width * 0.2, y: playableHeight * 0.4 + playableStart)
        player.spriteComponent.node.zPosition = Layer.player.rawValue
        addChild(player.spriteComponent.node)
        player.movementComponent.groundYPosition = playableStart
    }
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - margin)
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.text = "\(score)"
        worldNode.addChild(scoreLabel)
    }
    
    func createObstacle() -> SKSpriteNode {
        let obstacle = ObstacleEntity(imageName: "Cactus")
        let obstacleNode = obstacle.spriteComponent.node
        obstacleNode.zPosition = Layer.obstacle.rawValue
        obstacleNode.name = "Obstacle"
        obstacleNode.userData = NSMutableDictionary()
        return obstacleNode
    }
    
    func startSpawning() {
        let firstSpawnDelay = SKAction.wait(forDuration: firstObstacleSpawnDelay)
        let spawnNewObstacle = SKAction.run(spawnObstacle)
        let addDelayToNextSpawn = SKAction.wait(forDuration: eachObstacleSpawnDelay)
        
        let obstacleSpawnSequence = SKAction.sequence([spawnNewObstacle, addDelayToNextSpawn])
        let obstacleSpawnLoop = SKAction.repeatForever(obstacleSpawnSequence)
        let completeObstacleSpawnSequence = SKAction.sequence([firstSpawnDelay, obstacleSpawnLoop])
        run(completeObstacleSpawnSequence, withKey: "ObstacleSpawnSequence")
    }
    
    func stopSpawning() {
        removeAction(forKey: "ObstacleSpawnSequence")
        worldNode.enumerateChildNodes(withName: "Obstacle") { (node, stop) in
            node.removeAllActions()
        }
    }
    
    func spawnObstacle() {
        //Bottom obstacle
        let bottomObstacle = createObstacle()
        let startX = size.width + bottomObstacle.size.width / 2
        
        let bottomObstacleMinYPosition = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMinFraction
        let bottomObstacleMaxYPosition = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMaxFraction
        
        let randomSource = GKARC4RandomSource()
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: Int(round(bottomObstacleMinYPosition)), highestValue: Int(round(bottomObstacleMaxYPosition)))
        let startY = randomDistribution.nextInt()
        
        bottomObstacle.position = CGPoint(x: startX, y: CGFloat(startY))
        worldNode.addChild(bottomObstacle)
        
        //Top obstacle
        let topObstacle = createObstacle()
        topObstacle.zRotation = CGFloat(180).degreesToRadians()
        topObstacle.position = CGPoint(x: startX, y: bottomObstacle.position.y + bottomObstacle.size.height / 2 + topObstacle.size.height / 2 + gapMultiplier * player.spriteComponent.node.size.height)
        worldNode.addChild(topObstacle)
        
        let moveX = size.width + bottomObstacle.size.width
        let moveDuration = moveX / groundSpeed // t = X / V
        let sequence = SKAction.sequence([
            SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)),
            SKAction.removeFromParent()
            ])
        topObstacle.run(sequence)
        bottomObstacle.run(sequence)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "Background")
        
        background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background.position = CGPoint(x: size.width / 2, y: size.height)
        background.zPosition = Layer.background.rawValue
        worldNode.addChild(background)
        
        playableStart = size.height - background.size.height;
        playableHeight = background.size.height
        
        //Apply physics
        let lowerLeft = CGPoint(x: 0, y: playableStart)
        let lowerRight = CGPoint(x: size.width, y: playableStart)
        physicsBody = SKPhysicsBody(edgeFrom: lowerLeft, to: lowerRight)
        physicsBody?.categoryBitMask = PhysicsCategory.Ground
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    func setupForeground() {
        
        for i in 0..<numberOfForegrounds {
            let foreground = SKSpriteNode(imageNamed: "Ground")
            foreground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            foreground.position = CGPoint(x: CGFloat(i) * foreground.size.width, y: playableStart)
            foreground.zPosition = Layer.foreground.rawValue
            foreground.name = "Foreground"
            
            worldNode.addChild(foreground)
        }
    }
    
    /**
     * Responsible for moving the foreground tiles from out of screen on the left to the start of the queue
     * on the right of the screen. Used to animate the foreground to give a sense of progress in the game.
     */
    func updateForeground() {
        worldNode.enumerateChildNodes(withName: "Foreground") { (node, stop) in
            if let foreground = node as? SKSpriteNode {
                // Use set speed and the change in time to calculate distance covered in the last frame.
                // From formula: distance = speed x time.
                let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y: 0)
                foreground.position += moveAmount
                
                if foreground.position.x < -foreground.size.width {
                    foreground.position += CGPoint(x: foreground.size.width * CGFloat(self.numberOfForegrounds), y: 0)
                }
            }
        }
    }
    
    func updateScore() {
        worldNode.enumerateChildNodes(withName: "Obstacle") { (node, stop) in
            if let obstacle = node as? SKSpriteNode {
                if let passed = obstacle.userData?["Passed"] as? NSNumber {
                    if passed.boolValue {
                        return
                    }
                }
                
                let playerNode = self.player.spriteComponent.node
                if playerNode.position.x > obstacle.position.x + obstacle.size.width / 2 {
                    self.run(self.coinSoundAction)
                    self.score += 1
                    self.scoreLabel.text = "\(self.score / 2)"
                    obstacle.userData?["Passed"] = NSNumber(value: true as Bool)
                    obstacle.userData?.setValue(1, forKey: "Passed")
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let otherBody = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        if otherBody.categoryBitMask == PhysicsCategory.Ground {
            stateMachine.enter(GameOverState.self)
        }
        if otherBody.categoryBitMask == PhysicsCategory.Obstacle {
            stateMachine.enter(FallingState.self)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        stateMachine.update(deltaTime: currentTime)
        player.movementComponent.update(deltaTime: deltaTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    func restartGame(_ stateClass: AnyClass) {
        run(popSoundAction)
        let newScene = GameScene(size: size, stateClass: stateClass)
        let transition = SKTransition.fade(withDuration: 0.02)
        view?.presentScene(newScene, transition: transition)
    }
}
