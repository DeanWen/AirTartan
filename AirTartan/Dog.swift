//
//  Dog.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import SpriteKit

public class Dog : Startable {
    let node: SKSpriteNode!
    private let textureNames: [String]
    var dying = false
    private var textureForShape: SKTexture!
    
    var position : CGPoint {
        set {
            node.position = newValue
        }
        get {
            return node.position
        }
    }
    
    init(textureNames: [String]) {
        self.textureNames = textureNames
        node = createNode()
    }
    
    func addTo(scene: SKSpriteNode) -> Dog {
        scene.addChild(node)
        return self
    }
    
    private func createNode() -> SKSpriteNode {
        let dogNode = SKSpriteNode(imageNamed: textureNames.first!)
        textureForShape = SKTexture(imageNamed: textureNames.first!)
        dogNode.setScale(1.7)
        dogNode.zPosition = 2.0
        
        dogNode.physicsBody = SKPhysicsBody.textureSize(dogNode.size, inTexture: textureForShape) {
            body in
            body.dynamic = true
            body.usesPreciseCollisionDetection = true
            body.categoryBitMask = BodyType.dog.rawValue
            body.collisionBitMask = BodyType.dog.rawValue
            body.contactTestBitMask = BodyType.tartan.rawValue | BodyType.building.rawValue | BodyType.gap.rawValue
        }
        
        return dogNode
    }
    
    private func animate() {
        let animationFrames = textureNames.map { texName in
            SKTexture(imageNamed: texName)
        }
        
        node.runAction(
            SKAction.repeatActionForever(
                SKAction.animateWithTextures(animationFrames, timePerFrame: 0.1)
            ))
    }
    
    func update() {
        node.zRotation = node.physicsBody!.velocity.dy * 3.14 / 160
    }
    
    func up(y: Double) {
        if dying {
            return
        }
        node.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        node.physicsBody!.applyImpulse(CGVector(dx: 0, dy: -50 * y))
    }
    
    func down(y: Double) {
        if dying {
            return
        }
        node.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        node.physicsBody!.applyImpulse(CGVector(dx: 0, dy: -50 * y))
    }
    
    func pushDown() {
        node.runAction(SKAction.sequence(
            [
                SKAction.moveToY(node.position.y, duration: 1.0),
            ]
            )
        )
    }
    
    func start() -> Startable {
        animate()
        return self
    }
    
    func stop() -> Startable {
        node.physicsBody!.dynamic = false
        node.removeAllActions()
        return self
    }
}
