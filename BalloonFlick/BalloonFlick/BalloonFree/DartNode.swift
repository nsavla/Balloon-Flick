//
//  DartNode.swift
//  BalloonFree
//
//  Created by igmstudent on 5/3/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit
class DartNode: SKSpriteNode, CustomNodeEvents{
    func didMoveToScene() {
       print("Dart Moved to Scene")
    }
}