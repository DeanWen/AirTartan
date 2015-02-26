//
//  ParallaxNode.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import SpriteKit

// This is the movable object class
class ParallaxNode {
    private let node: SKSpriteNode!
    
    init(width: CGFloat, height: CGFloat, textureNamed: String) {
        let size = CGSizeMake(2 * width, height)
        node = SKSpriteNode(color: UIColor.whiteColor(), size: size)
        node.anchorPoint = CGPointZero
        node.position = CGPointZero
        
        // Use two duplicated objects to generate recurring movements
        node.addChild(createNode(textureNamed, x: 0))
        node.addChild(createNode(textureNamed, x: width))
    }
    
    private func createNode(textureNamed: String, x: CGFloat) -> SKNode {
        let node = SKSpriteNode(imageNamed: textureNamed, normalMapped: true)
        node.anchorPoint = CGPointZero
        node.position = CGPoint(x: x, y: 0)
        return node
    }
    
    func zPosition(zPosition: CGFloat) -> ParallaxNode {
        node.zPosition = zPosition
        return self
    }
    
    func addTo(parentNode: SKSpriteNode) -> ParallaxNode {
        parentNode.addChild(node)
        return self
    }
    
    // when object is 1/2 width out of screen, repeat from beginning
    func start(#duration: NSTimeInterval) {
        node.runAction(SKAction.repeatActionForever(SKAction.sequence(
            [
                SKAction.moveToX(-node.size.width / 2.0, duration: duration), SKAction.moveToX(0, duration: 0)
            ]
            )))
    }
    
    func stop() {
        node.removeAllActions()
    }
}
