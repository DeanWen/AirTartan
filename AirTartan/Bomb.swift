//
//  Bomb.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import SpriteKit

public class Bomb {
    let node: SKSpriteNode!
    private let textureNames: String
    private var textureForShape: SKTexture!
    
    var position : CGPoint {
        set {
            node.position = newValue
        }
        get {
            return node.position
        }
    }
    
    init(textureNames: String) {
        self.textureNames = textureNames
        node = createNode()
    }
    
    func addTo(scene: SKSpriteNode) -> Bomb {
        scene.addChild(node)
        return self
    }
    
    private func createNode() -> SKSpriteNode {
        let size = CGSize(width: 30,height: 30)
        let bbNode = SKSpriteNode(texture: SKTexture(imageNamed: "bullet"))
        bbNode.zPosition = 2.0
        
        bbNode.physicsBody = SKPhysicsBody.rectSize(size) {
            body in
            body.dynamic = true
            body.usesPreciseCollisionDetection = false
            body.categoryBitMask = BodyType.bomb.rawValue
            body.collisionBitMask = BodyType.bomb.rawValue
            body.contactTestBitMask = BodyType.building.rawValue
        }
        
        return bbNode
    }
    
    func upShoot() {
        node.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        node.physicsBody!.applyImpulse(CGVector(dx: 30, dy: 10))
    }
    
    func downShoot() {
        node.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        node.physicsBody!.applyImpulse(CGVector(dx: 30, dy: -10))
    }
}
