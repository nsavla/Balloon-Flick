//
//  SpikeNode.swift
//  BalloonFree
//
//  Created by igmstudent on 4/11/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class SpikeNode : SKSpriteNode , CustomNodeEvents {
    
     //MARK: - Node initialization -
    func didMoveToScene() {
        print("Spikes moved to scene")
        
        // Adding an emitter to spikenode
        let emitter = SKEmitterNode(fileNamed: "MyParticle")!
        addChild(emitter)
        
    }
}
