//
//  AddNameScene.swift
//  BalloonFree
//
//  Created by igmstudent on 4/16/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit
class AddNameScene : SKScene, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //MARK: - ivar -
    let titleLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    var DefaultName = ""
    let DoneButton = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    var  textField1 = UITextField()

    //MARK: - Initialization -
    convenience init(size:CGSize, name:String){
        self.init(size:size)
        DefaultName = name
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
        
        // defaults.setObject("Redder", forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper -
    override func didMoveToView(view: SKView) {
        
        // implementation of UI gesture
        let tap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        // Initialization of UI elements
        backgroundColor = SKColor(red: 0.0, green: 204.0, blue: 204.0, alpha: 1.0)
        titleLabel.text = "Add a New Name"
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 3 / 4)
        titleLabel.fontColor = SKColor.blackColor();
        titleLabel.fontSize =  CGFloat(120)
        addChild(titleLabel);
        
        DoneButton.text = "DONE"
        DoneButton.position = CGPoint(x: size.width / 2, y: size.height * 1 / 5)
        DoneButton.fontColor = SKColor.blackColor();
        DoneButton.fontSize =  CGFloat(60)
        addChild(DoneButton);
        
        //Implementing a TextField
        textField1.frame = CGRectMake(self.size.width/2 , self.size.height/2, 500, 100)
        textField1.center = CGPoint(x: size.width/2, y: size.height/2 );
        textField1.textColor = SKColor.blackColor()
        textField1.backgroundColor = SKColor.whiteColor()
        textField1.text = DefaultName
        textField1.delegate = self;
        self.view!.addSubview(textField1)
    }
    
    // MARK: - Gesture Handling -
    func tapDetected(sender:UITapGestureRecognizer) {
        
        
        let tappedNode = self.nodeAtPoint(self.convertPointFromView(sender.locationOfTouch(0, inView: view!)))
        // Select the appropiate scene
        if (tappedNode == DoneButton) {
            textField1.removeFromSuperview()
            DefaultName = (textField1.text)!
            let addNameScene = MainMenuScene(size: size, defaultName:DefaultName);
            view?.presentScene(addNameScene, transition:  SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))
            
        }
    }

}