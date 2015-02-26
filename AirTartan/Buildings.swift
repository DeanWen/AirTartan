//
//  Buildings.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import SpriteKit

class Buildings : Startable{
    private class var createActionKey : String {
        get {
            return "createActoinKey"
        }
    }
    
    private var parentNode: SKSpriteNode!
    private let textureNames: [String]
    
    init(textureNames: [String]) {
        self.textureNames = textureNames
    }
    
    func addTo(parentNode: SKSpriteNode) -> Buildings {
        self.parentNode = parentNode
        return self
    }
    
    func start() -> Startable {
        let createAction = SKAction.repeatActionForever(
            SKAction.sequence(
            [
                SKAction.runBlock {
                    self.createNewBuilding()
                }, SKAction.waitForDuration(1.2)
            ]
            )
        )
        parentNode.runAction(createAction, withKey: Buildings.createActionKey)
        
        return self
    }
    
    func stop() -> Startable {
        parentNode.removeActionForKey(Buildings.createActionKey)
        
        let buildingNodes = parentNode.children.filter {
            (node: AnyObject?) -> Bool in (node as SKNode).name == BuildingPair.kind
        }
        
        for building in buildingNodes {
            building.removeAllActions()
        }
        return self
    }
    
    private func createNewBuilding() {
        BuildingPair(textures: textureNames, centerY: centerBuildings()).addTo(parentNode).start()
    }
    
    private func centerBuildings() -> CGFloat {
        return parentNode.size.height/2 - 100 + 20 * CGFloat(arc4random_uniform(10))
    }
    
}
