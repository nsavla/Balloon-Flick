//
//  MainMenu.swift
//  BalloonFree
//
//  Created by igmstudent on 4/15/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

//MARK: - GLobal -
var playableRect:CGRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
class MainMenuScene : SKScene, UIGestureRecognizerDelegate {
 
    //MARK: - ivar -
    let defaults = NSUserDefaults.standardUserDefaults()
    let titleLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    let startButton = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    let PlayerName = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    let AddName = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    let Credits = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    
    //MARK: - intializers -
    convenience init(size:CGSize, defaultName:String){
        self.init(size: size)
        defaults.setObject(defaultName, forKey: "name")
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
        
        // To run an animation on MainScreen
        let BalloonBoySprite = SKSpriteNode(imageNamed: "BalloonBoy")
        BalloonBoySprite.position = CGPoint(x : size.width / 6 , y : -size.height / 2)
        BalloonBoySprite.setScale(0.5)
         BalloonBoySprite.zPosition = -1
        addChild(BalloonBoySprite)
        BalloonBoySprite.runAction( SKAction.sequence([
            SKAction.moveTo(CGPoint(x : size.width / 6 , y : size.height + BalloonBoySprite.size.height ), duration: 5.0)
            , SKAction.removeFromParent()]))
     
        
        //UIGestures
        let tap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        // Initialization of UI elements
        backgroundColor = SKColor(red: 0.0, green: 204.0, blue: 204.0, alpha: 1.0)
        titleLabel.text = MyConstants.MainMenuLabels.TitleLabel
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 3 / 4 + 40)
        titleLabel.fontColor = SKColor.blackColor();
        titleLabel.fontSize =  CGFloat(150)
        addChild(titleLabel);
        
     
        if(defaults.objectForKey("name")) == nil { defaults.setObject("XYZ", forKey: "name") }
        let playerName = defaults.objectForKey("name") ?? "XYZ"
        
        PlayerName.text = "Welcome \(playerName!)"
        PlayerName.position = CGPoint(x: size.width / 2, y: size.height / 2 + 120 );
        PlayerName.fontColor = SKColor.blackColor()
        PlayerName.fontSize = CGFloat(80)
        addChild(PlayerName);
        
        startButton.text = MyConstants.MainMenuLabels.StartLabel
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10);
        startButton.fontColor = SKColor.blackColor()
        startButton.fontSize = CGFloat(40)
        addChild(startButton);
        
        AddName.text = MyConstants.MainMenuLabels.NewNameLabel
        AddName.position = CGPoint(x: size.width / 2, y: (size.height * 3 / 8) - 20);
        AddName.fontColor = SKColor.blackColor()
        AddName.fontSize = CGFloat(40)
        addChild(AddName);
        
        Credits.text = MyConstants.MainMenuLabels.CreditLabel
        Credits.position = CGPoint(x: size.width / 2, y: size.height / 4 - 30);
        Credits.fontColor = SKColor.blackColor()
        Credits.fontSize = CGFloat(40)
        addChild(Credits);
        
        let logoNode = SKSpriteNode(imageNamed: "logo")
        logoNode.setScale(2.5)
        logoNode.position = CGPoint(x: size.width  * 5 / 6 , y: 120)
        addChild(logoNode)
        
        let BalloonSprite = SKSpriteNode(imageNamed: "BalloonRed")
        BalloonSprite.setScale(0.1)
        BalloonSprite.zRotation = 0.78539816339
        BalloonSprite.position = CGPoint(x: size.width * 5 / 6 - 30 , y: size.height / 2)
        addChild(BalloonSprite)
        
        let BalloonSprite2 = SKSpriteNode(imageNamed: "BalloonRed")
        BalloonSprite2.setScale(0.1)
        BalloonSprite2.zRotation = -0.78539816339
        BalloonSprite2.position = CGPoint(x: size.width * 5 / 6 + 35 , y: size.height / 2)
        addChild(BalloonSprite2)
        
        let SpikeBallSprite = SKSpriteNode(imageNamed: "spikeball")
        SpikeBallSprite.setScale(0.25)
        SpikeBallSprite.zRotation = -0.78539816339
        SpikeBallSprite.position = CGPoint(x: size.width * 5 / 6  , y: size.height / 2 - 80)
        addChild(SpikeBallSprite)
        
        let ScaleAction = SKAction.scaleBy(1.5, duration: 0.5)
        BalloonSprite.runAction( SKAction.repeatActionForever(SKAction.sequence([ ScaleAction, ScaleAction.reversedAction() ])))
        BalloonSprite2.runAction( SKAction.repeatActionForever(SKAction.sequence([ ScaleAction, ScaleAction.reversedAction() ])))
        SpikeBallSprite.runAction( SKAction.repeatActionForever(SKAction.sequence([ ScaleAction, ScaleAction.reversedAction() ])))
        // Play music file
        SKTAudio.sharedInstance().playBackgroundMusic("BackgroundMusic.wav")
        
    }
    
    //MARK: - Helpers -
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if (touchedNode == startButton) {
            startButton.fontColor = SKColor.redColor()
        }
    }
    
   
    // MARK: Gesture Handling
    func tapDetected(sender:UITapGestureRecognizer) {
        
        
        let tappedNode = self.nodeAtPoint(self.convertPointFromView(sender.locationOfTouch(0, inView: view!)))
        
        // Select the appropriate Scene
        if (tappedNode == startButton) {
           // let gameScene = GameScene.level(1)
             let levelMenuScene = LevelMenu(size: size);
            view?.presentScene(levelMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))
        } else if (tappedNode == AddName) {
            let playerName  = defaults.objectForKey("name") as! String
            let addNameScene = AddNameScene(size: size, name :  String(playerName));
            view?.presentScene(addNameScene, transition:  SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))
        } else if (tappedNode == Credits) {
            let addNameScene = CreditScene(size: size);
            view?.presentScene(addNameScene, transition:  SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))
            
        }
    }

    
}