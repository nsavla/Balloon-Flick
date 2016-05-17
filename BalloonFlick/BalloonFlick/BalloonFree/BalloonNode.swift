//
//  BalloonNode.swift
//  BalloonFree
//
//  Created by igmstudent on 4/11/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class BalloonNode : SKSpriteNode, CustomNodeEvents {
   
    //MARK: - Node initialization -
    func didMoveToScene(){
        print("balloon moved to scene")

        // Setting up of Physics Body
        physicsBody = SKPhysicsBody(circleOfRadius: 100.0)
        physicsBody?.mass = 1.33
        physicsBody?.affectedByGravity = false
        //physicsBody?.applyForce(CGVector(dx: 0.0, dy: 825.0))
        physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 150.0))
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.linearDamping = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 0.0
        
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 10
        physicsBody?.contactTestBitMask = 10
    }
}