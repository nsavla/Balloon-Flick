//
//  GameViewController.swift
//  BalloonFree
//
//  Created by igmstudent on 4/11/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // MARK: - ivars -
    // TODO: - GameScene not being initialized -
    var gameScene : GameScene?
    
    //MARK: - Initialization -
    override func viewDidLoad() {
        super.viewDidLoad()
        //used for pausing and events associated with pausing.
        setupNotifications()
        
        
        // Initialize from Main Menu
         let scene = MainMenuScene(size: CGSizeMake(1024, 768))

        //let scene = GameOverScene(size: CGSizeMake(1024,768), won: false, currentLevel: 1)
        // Uncomment this line if we want to initilaize from a specific level
        //if let scene = GameScene.level(4) {
        
        // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            // Play music file
            SKTAudio.sharedInstance().playBackgroundMusic("BackgroundMusic.wav")
        
        
        //Use this only when initializing first time so defaults reset
            for i in 1...MyConstants.GameVariables.MaxLevel - 1 {
               levelDefaults.setObject(nil, forKey: "Level\(i)")
                levelDefaults.setObject(nil, forKey: "StarLevel\(i)")
            }
        //}
    }

    
    //MARK: - Screen Status -
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Notifications -
    func setupNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("willResignActive:"),
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("didBecomeActive:"),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    //MARK: - Lifecycle Events -
    func willResignActive(n:NSNotification){
        print("willResignActive notification")
        gameScene?.gameLoopPaused = true
        
    }
    
    func didBecomeActive(n:NSNotification){
        print("didBecomeActive notification")
        gameScene?.gameLoopPaused = false
    }
    
    func teardownNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(
            self)
    }
    
}
