//
//  Tartan.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import SpriteKit

// This is the ground of the scene
class Tartan : Startable{
    private var parallaxNode: ParallaxNode!
    private let textureName: String
    
    // Initialize using an image
    init(textureNamed textureName: String) {
        self.textureName = textureName
    }
    
    func addTo(parentNode: SKSpriteNode!) -> Tartan {
        let width = parentNode.size.width
        let height = CGFloat(20.0)
        
        parallaxNode = ParallaxNode(width: width, height: height, textureNamed: textureName).zPosition(5).addTo(parentNode)
        
        // Add physical attributes
        let tartanBody = SKNode()
        tartanBody.position = CGPoint(x: width / 2.0, y: height / 2.0)
        tartanBody.physicsBody = SKPhysicsBody.rectSize(CGSize(width: width, height: height)) {
            body in
            body.dynamic = false
            body.affectedByGravity = false
            body.categoryBitMask = BodyType.tartan.rawValue
            body.collisionBitMask = BodyType.tartan.rawValue
        }
        parentNode.addChild(tartanBody)
        return self
    }

    func start() -> Startable {
        parallaxNode.start(duration: 5.0)
        return self
    }
    
    func stop() -> Startable {
        parallaxNode.stop()
        return self
    }
}