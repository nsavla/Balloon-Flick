//
// ShurikenNode.swift
//  BalloonFree
//
//  Created by igmstudent on 4/15/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit
class ShurikenNode : SKSpriteNode, CustomNodeEvents {
    
    //MARK: - Node initialization -
    func didMoveToScene() {
        print("Shurikens moved to scene")
        
        //TODO:- Initial Velcotiy not working
        // Setting up of Physics Body
        physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
        physicsBody?.mass = 1.33
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.angularVelocity = 5.0
        physicsBody?.friction = 0.0
        physicsBody?.categoryBitMask = 256
        physicsBody?.collisionBitMask = 9
        physicsBody?.contactTestBitMask = 9
        physicsBody?.affectedByGravity = false
        
        //TODO: - UTIL METHOD -
        // This is used to create a random variable.
        let sign = Int.random(min: 0,max: 1) == 0 ? -1 : 1
        // physicsBody?.applyForce(CGVectorMake(CGFloat.random(min: 1780.0 ,max: 1800.0) * CGFloat(sign), CGFloat.random(min: 1780.0 ,max: 1800.0) * CGFloat(sign)))
        physicsBody?.applyImpulse(CGVectorMake(CGFloat.random(min: 320.0 ,max: 500.0) * CGFloat(sign), CGFloat.random(min: 320.0 ,max: 500.0) * CGFloat(sign)))
        
    }
}