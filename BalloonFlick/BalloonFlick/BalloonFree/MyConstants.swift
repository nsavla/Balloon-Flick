//
//  MyConstants.swift
//  BalloonFree
//
//  Created by igmstudent on 4/19/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

struct MyConstants{
    struct Font {
        static let MainFont = "Noteworthy-Bold"
        static let LevelFont = "Arial"
    }
    
    struct Image{
        static let StartScreenLogo = "alien_top_01"
        static let Background = "background"
        static let Player_A = "spaceflier_01_a"
        static let Player_B = "spaceflier_01_b"
        static let Arrow = "arrow"
    }
    
    struct Collision {
        static let BalloonRock = "Collision between balloon and rock"
        static let BalloonSpike = "Collision between balloon and spike"
        static let BalloonBasketball = "Collision between balloon and basketball"
        static let BalloonBolt =  "Collision between balloon and bolt"
        static let BalloonDart =  "Collision between balloon and dart"
        static let BalloonShuriken =  "Collision between balloon and Shuriken"
        static let BalloonEdge = " SUCCESS! Collision between balloon and edge"
    }
    
    struct SwipeDirection {
        static let Up = "Swipe Up with speed - "
        static let Left = "Swipe Left with speed - "
        static let Right = "Swipe Right with speed - "
        static let Down = "Swipe Down with speed - "
        static let SwipeEnd = "The swipe ends at direction and speed - "
    }
    
    struct CreditLabels {
        static let TitleLabel = "Game designed and developed by -"
        static let DeveloperName = "Nishit Savla"
        static let DoneButton = "DONE"
    }
    
    struct MainMenuLabels {
        static let TitleLabel = "Balloon Flick"
        static let StartLabel = "Start Game"
        static let NewNameLabel = "Give a New Name"
        static let CreditLabel = "Credits"
    }
    
    struct GameVariables {
        static let MaxLevel = 10
    }
    
}

