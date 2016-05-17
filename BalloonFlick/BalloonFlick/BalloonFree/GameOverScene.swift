//
//  GameOverScene
//  BalloonFree
//
//  Created by igmstudent on 4/15/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene, UIGestureRecognizerDelegate {
    
    var currentLevel = 0
    var won = false
    var time = 0
   
    //MARK:- init -
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(size: CGSize, won:Bool, currentLevel:Int, time:Int){
        self.init(size: size, won:won, currentLevel:currentLevel)
        self.time = time
    }
    
    init(size: CGSize, won:Bool, currentLevel:Int) {
        
        super.init(size: size)
        self.currentLevel = currentLevel
        self.won = won
    }
    
     override func didMoveToView(view: SKView) {
        // As this is the maximum Level, we decrease it so that game does not crashes.
        
        
        if won == true {
            levelDefaults.setObject(true, forKey: "Level\(currentLevel - 1)")
              if levelDefaults.objectForKey("StarLevel\(currentLevel - 1)") == nil {
                    if(time > 800){
                        levelDefaults.setObject(3, forKey: "StarLevel\(currentLevel - 1)")
                    } else if time > 500 {
                        levelDefaults.setObject(2, forKey: "StarLevel\(currentLevel - 1)")
                    } else {
                        levelDefaults.setObject(1, forKey: "StarLevel\(currentLevel - 1)")
                    }
              } else {
                let stars = levelDefaults.objectForKey("StarLevel\(currentLevel - 1)") as? Int
                if stars == 1{
                    if(time > 800){
                        levelDefaults.setObject(3, forKey: "StarLevel\(currentLevel - 1)")
                    } else if time > 500 {
                        levelDefaults.setObject(2, forKey: "StarLevel\(currentLevel - 1)")
                    }
                } else if stars == 2 {
                    if(time > 800){
                        levelDefaults.setObject(3, forKey: "StarLevel\(currentLevel - 1)")
                    }
                }
            }
        }
       
        if(currentLevel == 0) {
            currentLevel++
        }

        
               
        //UIGestures
        let tap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        tap.delegate = self
        view.addGestureRecognizer(tap)

        SKTAudio.sharedInstance().pauseBackgroundMusic()
        // Lets us select the sound depending upon result.
        let SoundMessage = won ? "WinSound.wav" : "LoseSound.wav"
        //SKTAudio.sharedInstance().playSoundEffect(SoundMessage)
        let soundAction = SKAction.runBlock(){ SKTAudio.sharedInstance().playSoundEffect(SoundMessage)}
        runAction(SKAction.repeatActionForever( SKAction.sequence([soundAction, SKAction.waitForDuration(3.0)])))
        //runAction( SKAction.repeatActionForever(SKAction.runBlock(){ SKTAudio.sharedInstance().playSoundEffect(SoundMessage)}))
        //SKTAudio.sharedInstance().resumeBackgroundMusic()
        
        
        //TODO:- Adding images to background
        backgroundColor =  SKColor.blackColor()
        let message = won ? "You Won :-)" : "You Lose :-("

        if won == true {
        
            
            
            let balloonAnimation = SKSpriteNode(imageNamed: "WinBalloon")
            balloonAnimation.setScale(0.5)
            balloonAnimation.position = CGPoint(x: size.width/2 , y: -size.height/2)
            balloonAnimation.zPosition = -1
            addChild(balloonAnimation)
            balloonAnimation.runAction(SKAction.moveTo(CGPoint(x: size.width/2, y: size.height), duration: 3.0))
            
            let label = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
            label.text = message
            label.fontSize = 200
            label.fontColor = SKColor.redColor()
            label.zPosition = 2
            label.position = CGPoint(x: size.width/2, y: size.height/2 + 150)
            addChild(label)
            
            let mainMenuButton = SKSpriteNode(imageNamed: "buttonRed")
            mainMenuButton.position = CGPoint(x: size.width/3 - 80, y: size.height / 4 + 30)
            mainMenuButton.setScale(1.3)
            mainMenuButton.zPosition = 2
            mainMenuButton.name = "MainMenu"
            addChild(mainMenuButton)
            let mainMenuLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
            mainMenuLabel.position = CGPoint(x: 0, y: -10)
            mainMenuLabel.zPosition = 3
            mainMenuLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            mainMenuLabel.fontColor = SKColor.greenColor()
            mainMenuLabel.text = "Main Menu"
             mainMenuLabel.name = "MainMenu"
            mainMenuButton.addChild(mainMenuLabel)
            
            
            
            let nextLevelButton = SKSpriteNode(imageNamed: "buttonGreen")
            nextLevelButton.position = CGPoint(x: size.width * 2/3 + 60, y: size.height / 4 + 30)
            nextLevelButton.zPosition = 2
            nextLevelButton.name = "NextLevel"
            nextLevelButton.setScale(1.3)
            addChild(nextLevelButton)
            let nextLevelLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
            nextLevelLabel.position = CGPoint(x: 0, y: -10)
            nextLevelLabel.zPosition = 3
            nextLevelLabel.fontColor = SKColor.redColor()
            nextLevelLabel.text = "Next Level"
             nextLevelLabel.name = "NextLevel"
            nextLevelButton.addChild(nextLevelLabel)
            
            
            let ReplayButton = SKSpriteNode(imageNamed: "buttonYellow")
            ReplayButton.position = CGPoint(x: size.width / 2 , y: size.height / 4 - 70)
            ReplayButton.setScale(1.3)
            ReplayButton.zPosition = 2
            ReplayButton.name = "Replay"
            addChild(ReplayButton)
            let ReplayLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
            ReplayLabel.position = CGPoint(x: 0, y: -30)
            ReplayLabel.zPosition = 3
            ReplayLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            ReplayLabel.fontColor = SKColor.blackColor()
            ReplayLabel.text = "Replay"
            ReplayLabel.name = "Replay"
            ReplayButton.addChild(ReplayLabel)
            
            
            let levelTile = SKSpriteNode(imageNamed: "levelTile")
            levelTile.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(levelTile)
            let LevelLabel = SKLabelNode(fontNamed: MyConstants.Font.LevelFont)
            let index = currentLevel - 1
            LevelLabel.text = "\(index)"
            LevelLabel.zPosition = 1
            LevelLabel.name = "LevelLabel\(index)"
            LevelLabel.setScale(3.5)
            LevelLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 40)
            LevelLabel.fontColor = SKColor.yellowColor()
            addChild(LevelLabel)
        
            let NoOfstars = levelDefaults.objectForKey("StarLevel\(currentLevel - 1)") as? Int
            if NoOfstars != nil {
                if(NoOfstars == 1)
                {
                    let star = SKSpriteNode(imageNamed: "star")
                    star.zPosition = 2
                    star.position = CGPoint(x: levelTile.position.x  , y: levelTile.position.y - 90)
                    star.setScale(0.0)
                    addChild(star)
                    star.runAction(SKAction.scaleTo(0.6, duration: 0.5))
                }
                else if(NoOfstars == 2)
                {
                    let star = SKSpriteNode(imageNamed: "star")
                    star.zPosition = 2
                    star.position = CGPoint(x: levelTile.position.x + 30 , y: levelTile.position.y - 90)
                    star.setScale(0.0)
                    addChild(star)
                    
                    let star2 = SKSpriteNode(imageNamed: "star")
                    star2.zPosition = 2
                    star2.position = CGPoint(x: levelTile.position.x - 30 , y: levelTile.position.y - 90)
                    star2.setScale(0.0)
                    addChild(star2)
                    
                    star.runAction(SKAction.scaleTo(0.6, duration: 0.5))
                    star2.runAction(SKAction.scaleTo(0.6, duration: 0.5))
                }
                else if(NoOfstars == 3)
                {
                    let star = SKSpriteNode(imageNamed: "star")
                    star.zPosition = 2
                    star.position = CGPoint(x: levelTile.position.x + 55 , y: levelTile.position.y - 90)
                    star.setScale(0.0)
                    addChild(star)
                    
                    let star2 = SKSpriteNode(imageNamed: "star")
                    star2.zPosition = 2
                    star2.position = CGPoint(x: levelTile.position.x  , y: levelTile.position.y - 90)
                    star2.setScale(0.0)
                    addChild(star2)
                    
                    let star3 = SKSpriteNode(imageNamed: "star")
                    star3.zPosition = 2
                    star3.position = CGPoint(x: levelTile.position.x - 55 , y: levelTile.position.y - 90)
                    star3.setScale(0.0)
                    addChild(star3)
                    
                    star.runAction(SKAction.scaleTo(0.6, duration: 0.5))
                    star2.runAction(SKAction.scaleTo(0.6, duration: 0.5))
                    star3.runAction(SKAction.scaleTo(0.6, duration: 0.5))
                    
                }
            }
            
            
            
            
            
        } else {
        // Create a Label for Result Screen
        let label = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
        label.text = message
        label.fontSize = 200
        label.fontColor = SKColor.redColor()
            label.zPosition = 3
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
            
            
            let mainMenuButton = SKSpriteNode(imageNamed: "buttonRed")
            mainMenuButton.position = CGPoint(x: size.width/3 - 10, y: size.height / 4)
            mainMenuButton.setScale(1.5)
            mainMenuButton.zPosition = 2
            mainMenuButton.name = "MainMenu"
            addChild(mainMenuButton)
            let mainMenuLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
            mainMenuLabel.position = CGPoint(x: 0, y: -10)
            mainMenuLabel.zPosition = 3
            mainMenuLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            mainMenuLabel.fontColor = SKColor.greenColor()
            mainMenuLabel.text = "Main Menu"
            mainMenuLabel.name = "MainMenu"
            mainMenuButton.addChild(mainMenuLabel)
            
            
            
            let nextLevelButton = SKSpriteNode(imageNamed: "buttonGreen")
            nextLevelButton.position = CGPoint(x: size.width * 2/3 + 10, y: size.height / 4)
            nextLevelButton.zPosition = 2
            nextLevelButton.name = "Restart"
            nextLevelButton.setScale(1.5)
            addChild(nextLevelButton)
            let nextLevelLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
            nextLevelLabel.position = CGPoint(x: 0, y: -10)
            nextLevelLabel.zPosition = 3
            nextLevelLabel.fontColor = SKColor.redColor()
            nextLevelLabel.text = "Restart"
            nextLevelLabel.name = "Restart"
            nextLevelButton.addChild(nextLevelLabel)
            
            
            let PurpleBalloon = SKSpriteNode(imageNamed: "Purple1")
            PurpleBalloon.setScale(0.8)
            PurpleBalloon.position = CGPoint(x: size.width * 4 / 5 + 70, y: size.height/2 + 200)
            addChild(PurpleBalloon)
            let PurpleBalloonAnimation : SKAction
            var textures:[SKTexture] = []
            for i in 1...9 {
                textures.append(SKTexture(imageNamed: "Purple\(i)"))
            }
            PurpleBalloonAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
            PurpleBalloon.runAction(SKAction.repeatActionForever(PurpleBalloonAnimation))

            
            let GreenBalloon = SKSpriteNode(imageNamed: "GreenBalloon1")
            GreenBalloon.setScale(0.8)
            GreenBalloon.position = CGPoint(x: size.width * 3 / 5 + 20, y: size.height/2 + 200)
            addChild(GreenBalloon)
            let GreenBalloonAnimation : SKAction
            var Greentextures:[SKTexture] = []
            for i in 1...8 {
                Greentextures.append(SKTexture(imageNamed: "GreenBalloon\(i)"))
            }
            GreenBalloonAnimation = SKAction.animateWithTextures(Greentextures, timePerFrame: 0.2)
            GreenBalloon.runAction(SKAction.repeatActionForever(GreenBalloonAnimation))
            
            let RedBalloon = SKSpriteNode(imageNamed: "RedBalloon1")
            RedBalloon.setScale(0.8)
            RedBalloon.position = CGPoint(x: size.width * 2 / 5 - 30, y: size.height/2 + 200)
            addChild(RedBalloon)
            let RedBalloonAnimation : SKAction
            var Redtextures:[SKTexture] = []
            for i in 1...7 {
                Redtextures.append(SKTexture(imageNamed: "RedBalloon\(i)"))
            }
            RedBalloonAnimation = SKAction.animateWithTextures(Redtextures, timePerFrame: 0.2)
            RedBalloon.runAction(SKAction.repeatActionForever(RedBalloonAnimation))
            
            
            let SilverBalloon = SKSpriteNode(imageNamed: "SilverBalloon1")
            SilverBalloon.setScale(0.8)
            SilverBalloon.position = CGPoint(x: size.width * 1 / 5 - 70, y: size.height/2 + 200)
            addChild(SilverBalloon)
            let SilverBalloonAnimation : SKAction
            var Silvertextures:[SKTexture] = []
            for i in 1...6 {
                Silvertextures.append(SKTexture(imageNamed: "SilverBalloon\(i)"))
            }
            SilverBalloonAnimation = SKAction.animateWithTextures(Silvertextures, timePerFrame: 0.2)
            SilverBalloon.runAction(SKAction.repeatActionForever(SilverBalloonAnimation))

            
        }
           }
   
    
    
    // MARK: Gesture Handling
    func tapDetected(sender:UITapGestureRecognizer) {
        
        
        let tappedNode = self.nodeAtPoint(self.convertPointFromView(sender.locationOfTouch(0, inView: view!)))
        
        // Select the appropriate Scene
        if (tappedNode.name == "MainMenu") {
            SKTAudio.sharedInstance().resumeBackgroundMusic()
            self.view?.presentScene(MainMenuScene(size:size), transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))
        } else if (tappedNode.name == "NextLevel") {
            SKTAudio.sharedInstance().resumeBackgroundMusic()

            if(currentLevel == MyConstants.GameVariables.MaxLevel)
            {
                currentLevel--
            }
            if let scene = GameScene.level(self.currentLevel)
            {
                self.view?.presentScene(scene, transition:SKTransition.flipHorizontalWithDuration(0.5))
            }
        } else if (tappedNode.name == "Restart") {
            SKTAudio.sharedInstance().resumeBackgroundMusic()

            if let scene = GameScene.level(self.currentLevel)
            {
                self.view?.presentScene(scene, transition:SKTransition.flipHorizontalWithDuration(0.5))
            }
        } else if (tappedNode.name == "Replay") {
            SKTAudio.sharedInstance().resumeBackgroundMusic()
            
            if let scene = GameScene.level(self.currentLevel - 1)
            {
                self.view?.presentScene(scene, transition:SKTransition.flipHorizontalWithDuration(0.5))
            }
        }
    }
}