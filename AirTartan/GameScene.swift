//
//  GameScene.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

enum BodyType : UInt32 {
    case dog = 1
    case tartan = 2
    case building = 4
    case gap = 8
    case bomb = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var screenNode: SKSpriteNode!
    private var actors: [Startable]!    // collections of objects
    private var endActors: [Startable]! // coleections of objects need to be stopped
    private var dog: Dog!
    private var touch: UITouch!
    private var touchLocation: CGPoint!
    private var score = 0
    private var startLabel: SKSpriteNode!   // "tap to start" label
    
    private var building : Buildings!
    private var gameover = true
    private var scoreLabel = SKLabelNode()
    private let motionManager: CMMotionManager = CMMotionManager()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // main scene
        screenNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        addChild(screenNode)
        
        // create main objects
        let rainbow = Rainbow(textureNamed: "rainbow").addTo(screenNode)
        let tartan = Tartan(textureNamed: "tartan").addTo(screenNode)
        dog = Dog(textureNames: ["dog1", "dog2"]).addTo(screenNode)
        dog.position = CGPointMake(50.0, 200.0)
        
        building = Buildings(textureNames: ["upitt2", "upitt"]).addTo(screenNode)

        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 30
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(50, self.frame.size.height - 100)
        scoreLabel.zPosition = 20
        self.addChild(scoreLabel)
        
        actors = [rainbow,tartan, dog, building]
        endActors = [rainbow, tartan, building]
        
        startLabel = SKSpriteNode(imageNamed:"go")
        startLabel.position = CGPointMake(284, 160)
        self.addChild(startLabel)
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
            deviceManager, error in
            self.motion()
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scoreAdd", name: "ADD_SCORE", object: nil)
    }
    
    func motion() {
        if self.motionManager.deviceMotion.attitude.quaternion.y > 0 {
            dog.down(self.motionManager.deviceMotion.attitude.quaternion.y)
        } else {
            dog.up(self.motionManager.deviceMotion.attitude.quaternion.y)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if gameover == true {
            // initialize states and start game
            dog.dying = false
            dog.position = CGPointMake(50.0, 200.0)
            
            dog.node.physicsBody?.dynamic = true
            gameover = false
            
            for actor in actors {
                actor.start()
            }
            
            score = 0
            scoreLabel.text = "0"
            
            startLabel?.removeFromParent()
        }
        else {
            // control the dog to shoot bullets
            touch = touches.anyObject() as UITouch
            touchLocation = touch.locationInNode(screenNode)
            if touchLocation.y >= 160 {
                if score > 0 {
                    let bb = Bomb(textureNames: "bullet").addTo(screenNode)
                    bb.position = dog.node.position
                    bb.upShoot()
                    scoreDec()
                }
            } else {
                if score > 0 {
                    let bb = Bomb(textureNames: "bullet").addTo(screenNode)
                    bb.position = dog.node.position
                    bb.downShoot()
                    scoreDec()
                }
            }
        }
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        dog.update()
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch (contactMask) {
        case BodyType.building.rawValue | BodyType.dog.rawValue:
            println("Contact with a building")
            // hit a building and remove other objects
            for endActor in endActors {
                endActor.stop()
            }
            endOfGame()
        case BodyType.tartan.rawValue | BodyType.dog.rawValue:
            // hit the ground and remove other objects
            println("Contact with tartan")
            for actor in actors {
                actor.stop()
            }
            endOfGame()
        case BodyType.bomb.rawValue | BodyType.building.rawValue:
            println("BOMB!")
            // remove both bomb and buidling
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
        default:
            return
        }
    }
    
    // remove all objects
    func endOfGame() {
        // all moving buildings need to be removed
        let buildingNodes = screenNode.children.filter {
            (node: AnyObject?) -> Bool in (node as SKNode).name == BuildingPair.kind
        }
        for building in buildingNodes {
            building.removeFromParent()
        }
        
        gameover = true
        
        NSNotificationCenter.defaultCenter().postNotificationName("GAME_OVER", object: nil)
    }
    
    func scoreAdd() {
        score++
        scoreLabel.text = String(score)
    }
    
    func scoreDec() {
        score--
        scoreLabel.text = String(score)
    }
    
    func getScore() -> Int {
        return score
    }
    
    func didEndContact(contact: SKPhysicsContact!) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch (contactMask) {
        case BodyType.gap.rawValue | BodyType.dog.rawValue:
            println("Exit from gap")
        default:
            return
        }
    }
}
