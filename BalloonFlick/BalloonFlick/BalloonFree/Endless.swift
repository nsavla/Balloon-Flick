//
//  Endless.swift
//  BalloonFlick
//
//  Created by igmstudent on 5/15/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class EndlessScene: SKScene , SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
 
    //MARK: - Initialization -
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        let playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width, height: size.height-playableMargin*2)
    
        //Setting up the physics body of Screen
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        enumerateChildNodesWithName("//*", usingBlock: {node, _ in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
            }
        })
        
        balloonNode = childNodeWithName("//balloonBody") as? BalloonNode
        rockNode = childNodeWithName("rockBody") as? RockNode
        spikeNode = childNodeWithName("spikeBody") as? SpikeNode
        
    }
}