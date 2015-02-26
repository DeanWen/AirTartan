//
//  Rainbow.swift
//  AirTartan
//
//  Copyright (c) Team 2014 Air Crew. All rights reserved.
//

import SpriteKit

// This is the background
class Rainbow : Startable{
    private var parallaxNode: ParallaxNode!
    private let textureName: String
    private var selfWidth : CGFloat
    
    init(textureNamed textureName: String) {
        self.textureName = textureName
        let node = SKSpriteNode(imageNamed: textureName, normalMapped: true)
        self.selfWidth = node.size.width
    }
    
    // Add to the parent node of the scene
    func addTo(parentNode: SKSpriteNode!) -> Rainbow {
        let width = selfWidth - 1 // 1 point overlapped
        let height = parentNode.size.height
        
        parallaxNode = ParallaxNode(width: width, height: height, textureNamed: textureName).addTo(parentNode)
        
        return self
    }
    
    func start() -> Startable {
        parallaxNode.start(duration: 30.0)
        return self
    }
    
    func stop() -> Startable {
        parallaxNode.stop()
        return self
    }
    
}
