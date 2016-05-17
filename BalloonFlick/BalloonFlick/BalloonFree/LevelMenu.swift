//
//  LevelMenu.swift
//  BalloonFree
//
//  Created by igmstudent on 4/30/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

public var levelDefaults = NSUserDefaults.standardUserDefaults()

class LevelMenu : SKScene, UIGestureRecognizerDelegate{
    
    var levelTiles  = [SKSpriteNode]()
    var DefaultLevelText : SKLabelNode?
   // let defaults = NSUserDefaults.standardUserDefaults()
    
    convenience init(size:CGSize, defaultName:String){
        self.init(size: size)
        //defaults.setObject(defaultName, forKey: "name")
    }
    
    override init(size:CGSize){
        super.init(size: size)
        print("Size: \(size)")
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio;
        print(playableHeight)
        let playableMargin = (size.height-playableHeight)/2.0
        print(playableMargin)
        playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width,
            height: playableHeight)
        print(playableRect.minY)
        print(playableRect.maxY)
        
        //defaults.setObject("Redder", forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        // Initialization of UI elements
        backgroundColor = SKColor(red: 0.0, green: 204.0, blue: 204.0, alpha: 1.0)
        
        print(" The level defaults are - ")
        print(levelDefaults.objectForKey("Level1"))
          print(levelDefaults.objectForKey("Level2"))
          print(levelDefaults.objectForKey("Level3"))
          print(levelDefaults.objectForKey("Level4"))
        print(levelDefaults.objectForKey("Level5"))
        
        
        var XPosition = size.width / 4
        var YPosition = size.height * 3 / 4 + 20
        
        for i in 1...MyConstants.GameVariables.MaxLevel - 1 {
            let levelTile = SKSpriteNode(imageNamed: "levelTile")
            levelTile.position = CGPoint(x: XPosition , y: YPosition)
            levelTile.setScale(0.7)
            let lock = SKSpriteNode(imageNamed: "lock")
            lock.zPosition = 1
            lock.name = "lock"
            lock.setScale(0.4)
            levelTile.addChild(lock)
            addChild(levelTile)
            levelTiles.append(levelTile)
            XPosition = XPosition + 250
            if i == 3 {
                XPosition = size.width / 4
                YPosition = YPosition / 2 + 90
            } else if i == 6 {
                XPosition = size.width / 4
                YPosition = YPosition  / 4 + 70
            }
        }
        
        
        
        
        var j = 0
            for i in 0...MyConstants.GameVariables.MaxLevel - 2 {
                let index = levelTiles.indexOf(levelTiles[i])! + 1
                if( levelDefaults.objectForKey("Level\(index)") !=  nil) {
                    
                    levelTiles[i].childNodeWithName("lock")?.removeFromParent()
                    let LevelLabel = SKLabelNode(fontNamed: MyConstants.Font.LevelFont)
                    let index = levelTiles.indexOf(levelTiles[i])! + 1
                    print("Star Level Index is - \(levelDefaults.objectForKey("StarLevel\(index)"))")
                    LevelLabel.text = "\(i+1)"
                    LevelLabel.zPosition = 1
                    LevelLabel.name = "LevelLabel\(index)"
                    LevelLabel.setScale(2.5)
                    LevelLabel.position = CGPoint(x: levelTiles[i].position.x , y: levelTiles[i].position.y - 30)
                    LevelLabel.fontColor = SKColor.yellowColor()
                    addChild(LevelLabel)
                    
                    var NoOfStars = 0
                    if let stars = levelDefaults.objectForKey("StarLevel\(index)") as? Int {
                        NoOfStars = Int(stars)
                    }
                    showStars(NoOfStars, Position : CGPoint(x: LevelLabel.position.x, y: LevelLabel.position.y - 40))
                   
                    
                } else {
                    j = i
                    break
                }
            }
        
        levelTiles[j].childNodeWithName("lock")?.removeFromParent()
        let LevelLabel = SKLabelNode(fontNamed: MyConstants.Font.LevelFont)
        let index = levelTiles.indexOf(levelTiles[j])! + 1
        //print("Level Index is - \(index)")
        LevelLabel.text = "\(index)"
        LevelLabel.zPosition = 1
        LevelLabel.name = "LevelLabel\(index)"
        levelTiles[j].name = "LevelLabel\(index)"
        LevelLabel.setScale(2.5)
        LevelLabel.position = CGPoint(x: levelTiles[j].position.x , y: levelTiles[j].position.y - 30)
        LevelLabel.fontColor = SKColor.yellowColor()
        addChild(LevelLabel)
        DefaultLevelText = LevelLabel
        
        //UIGestures
        let tap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
    }
    
    func showStars(NoOfStars : Int, Position : CGPoint){
 
        if(NoOfStars == 1)
        {
            let star = SKSpriteNode(imageNamed: "star")
            star.zPosition = 2
            star.position = CGPoint(x: Position.x  , y: Position.y)
            star.setScale(0.6)
            addChild(star)
        }
        else if(NoOfStars == 2)
        {
            var star = SKSpriteNode(imageNamed: "star")
            star.zPosition = 2
            star.position = CGPoint(x: Position.x - 25 , y: Position.y)
            star.setScale(0.6)
            addChild(star)
            
             star = SKSpriteNode(imageNamed: "star")
            star.zPosition = 2
            star.position = CGPoint(x: Position.x + 25, y: Position.y)
            star.setScale(0.6)
            addChild(star)
        }
        else if(NoOfStars == 3)
        {
            var star = SKSpriteNode(imageNamed: "star")
            star.zPosition = 2
            star.position = CGPoint(x: Position.x - 50 , y: Position.y)
            star.setScale(0.6)
            addChild(star)
            
             star = SKSpriteNode(imageNamed: "star")
            star.zPosition = 2
            star.position = CGPoint(x: Position.x  , y: Position.y)
            star.setScale(0.6)
            addChild(star)
            
             star = SKSpriteNode(imageNamed: "star")
            star.zPosition = 2
            star.position = CGPoint(x: Position.x + 50, y: Position.y )
            star.setScale(0.6)
            addChild(star)
        }
    }
    
    
    
    
    func tapDetected(sender:UITapGestureRecognizer) {
        let tappedNode = self.nodeAtPoint(self.convertPointFromView(sender.locationOfTouch(0, inView: view!)))
       
        
        // Without using defaultLeveltext, it was not working and tappednode was showing as unititalized. HJence, this is a patch
        // This shows up when the next value is nil
        if tappedNode.name == nil {
        
           tappedNode.name = DefaultLevelText?.text
            
        }
        
        switch tappedNode.name! {
        case "LevelLabel1","LevelLabel2","LevelLabel3","LevelLabel4","LevelLabel5","LevelLabel6","LevelLabel7","LevelLabel8" , "LevelLabel9"  :
               // let label = tappedNode as? SKLabelNode
                let label = tappedNode.name
                let charindex = label?[label!.startIndex.advancedBy(10)]
                let index = Int(String(charindex!))
                print(" The level in leveldefaults selected is - \(index)")
                let gameScene = GameScene.level(index!)
                 view?.presentScene(gameScene!, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))

        default : break
        }
        
        
    }
    
    
    
    
}