//
//  RockNode.swift
//  BalloonFree
//
//  Created by igmstudent on 4/11/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit
class RockNode : SKSpriteNode, CustomNodeEvents {
    
     //MARK: - Node initialization -
    func didMoveToScene(){
        print("rock moved to scene")
    }
}