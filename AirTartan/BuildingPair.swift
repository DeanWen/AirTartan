//
//  BuildingPair.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import SpriteKit

class BuildingPair {
    class var kind : String {
        get {
            return "BUILDINGS"
        }
    }
    
    private let gapSize: CGFloat = 50
    private var buildingsNode: SKNode!
    private var finalOffset: CGFloat!
    private var startingOffset: CGFloat!
    private var buildingNumber: UInt32!
    private var buildingName1: String
    private var buildingName2: String
    private var textureForBuildings: SKTexture!
    
    init(textures: [String], centerY: CGFloat) {
        buildingsNode = SKNode()
        buildingsNode.name = BuildingPair.kind
        
        buildingNumber = arc4random_uniform(5)
        switch (buildingNumber) {
        case 1:
            buildingName1 = "dome2"
            buildingName2 = "dome"
        case 2:
            buildingName1 = "ucb2"
            buildingName2 = "ucb"
        case 3:
            buildingName1 = "stan2"
            buildingName2 = "stan"
        case 4:
            buildingName1 = "stata2"
            buildingName2 = "stata"
        default:
            buildingName1 = "upitt2"
            buildingName2 = "upitt"
        }
        
        let buildingTop = createBuilding(imageNamed: buildingName1)
        let buildingTopPosition = CGPoint(x: 0, y: centerY + buildingTop.size.height / 2 + gapSize)
        buildingTop.position = buildingTopPosition
        buildingsNode.addChild(buildingTop)
        
        let buildingBottom = createBuilding(imageNamed: buildingName2)
        let buildingBottomPosition = CGPoint(x: 0, y: centerY - buildingBottom.size.height / 2 - gapSize)
        buildingBottom.position = buildingBottomPosition
        buildingsNode.addChild(buildingBottom)
        
        let gapNode = createGap(size: CGSize(width: buildingBottom.size.width, height: gapSize * 2))
        gapNode.position = CGPoint(x: 0, y: centerY)
        buildingsNode.addChild(gapNode)
        
        finalOffset = -buildingBottom.size.width/2
        startingOffset = -finalOffset
    }
    
    func addTo(parentNode: SKSpriteNode) -> BuildingPair {
        let buildingPosition = CGPoint(x: parentNode.size.width + startingOffset, y: 0)
        buildingsNode.position = buildingPosition
        
        parentNode.addChild(buildingsNode)
        
        return self
    }
    
    func start() {
        buildingsNode.runAction(SKAction.sequence(
            [
                SKAction.moveToY(50.0, duration: 3.0),
                SKAction.moveToY(-50.0, duration: 3.0)
            ]
            )
        )
        buildingsNode.runAction(SKAction.sequence(
            [
                SKAction.moveToX(finalOffset, duration: 5.0),
                SKAction.removeFromParent()
            ]
            )
        )
    }
    
    private func createBuilding(#imageNamed: String) -> SKSpriteNode {
        let buildingNode = SKSpriteNode(imageNamed: imageNamed)
        textureForBuildings = SKTexture(imageNamed: imageNamed)
        
        buildingNode.physicsBody = SKPhysicsBody.textureSize(buildingNode.size, inTexture: textureForBuildings) {
            body in
            body.dynamic = false
            body.usesPreciseCollisionDetection = true
            body.affectedByGravity = false
            body.categoryBitMask = BodyType.building.rawValue
            body.collisionBitMask = BodyType.building.rawValue
        }
        return buildingNode
    }
    
    private func createGap(#size: CGSize) -> SKSpriteNode {
        let gapNode = SKSpriteNode(color: UIColor.clearColor(), size: size)
        
        gapNode.physicsBody = SKPhysicsBody.rectSize(gapNode.size) {
            body in
            body.dynamic = false
            body.usesPreciseCollisionDetection = true
            body.affectedByGravity = false
            body.categoryBitMask = BodyType.gap.rawValue
            body.collisionBitMask = BodyType.gap.rawValue
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("ADD_SCORE", object: nil)
        
        return gapNode
    }
}
