//
//  BoltNode.swift
//  BalloonFree
//
//  Created by igmstudent on 5/5/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit
class BoltNode : SKSpriteNode {
    init(){
        let texture = SKTexture(imageNamed: "bolt")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
