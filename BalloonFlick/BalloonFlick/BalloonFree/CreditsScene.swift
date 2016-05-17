//
//  CreditsScene.swift
//  BalloonFree
//
//  Created by igmstudent on 4/19/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit
class CreditScene : SKScene, UIGestureRecognizerDelegate {
    
    //MARK: - ivar -
    let titleLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    let CreditLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    let DoneButton = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    
    //MARK: - initialization -
    convenience init(size:CGSize, name:String){
        self.init(size:size)
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
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper -
    override func didMoveToView(view: SKView) {
        print("Credits Scene Started")
        
        // Initialization of UI elements
        backgroundColor = SKColor(red: 0.0, green: 204.0, blue: 204.0, alpha: 1.0)

        //UI Gestures
        let tap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        //backgroundColor = SKColor.blackColor();
        titleLabel.text = MyConstants.CreditLabels.TitleLabel
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 3 / 4)
        titleLabel.fontColor = SKColor.blackColor();
        titleLabel.fontSize =  CGFloat(70)
        addChild(titleLabel);
        
        CreditLabel.text = MyConstants.CreditLabels.DeveloperName
        CreditLabel.position = CGPoint(x: size.width / 2, y: size.height * 1 / 2)
        CreditLabel.fontColor = SKColor.blackColor();
        CreditLabel.fontSize =  CGFloat(125)
        addChild(CreditLabel);
        
        DoneButton.text = MyConstants.CreditLabels.DoneButton
        DoneButton.position = CGPoint(x: size.width / 2, y: size.height * 1 / 5)
        DoneButton.fontColor = SKColor.blackColor();
        DoneButton.fontSize =  CGFloat(60)
        addChild(DoneButton);

    }
    
    // MARK: Gesture Handling
    func tapDetected(sender:UITapGestureRecognizer) {
        let tappedNode = self.nodeAtPoint(self.convertPointFromView(sender.locationOfTouch(0, inView: view!)))
        if (tappedNode == DoneButton) {
            let addNameScene = MainMenuScene(size: size);
            view?.presentScene(addNameScene, transition:  SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0))
        }
    }

    
}