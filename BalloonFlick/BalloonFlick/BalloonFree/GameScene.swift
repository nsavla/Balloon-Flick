//
//  GameScene.swift
//  BalloonFree
//
//  Created by igmstudent on 4/11/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import SpriteKit

//MARK:- Struct -
struct PhysicsCategory{
    static let None:    UInt32 =     0
    static let Balloon: UInt32 =     0b1        // 1
    static let Rock:    UInt32 =     0b10       // 2
    static let Bird:    UInt32 =     0b100      // 4
    static let Edge:    UInt32 =     0b1000     // 8
    static let Spike:   UInt32 =     0b10000    //16
    static let Basketball : UInt32 = 0b100000   //32
    static let Bolt:    UInt32 =     0b1000000  //64
    static let Dart: UInt32 =        0b10000000 //128
    static let Shuriken : UInt32 =   0b100000000//256
}

//MARK:- Protocols -
protocol CustomNodeEvents {
    func didMoveToScene ()
}

protocol InteractiveNode {
    func interact()
}

//MARK: - GLobals -
var balloonNode : BalloonNode!
var rockNode : RockNode!
var spikeNode : SpikeNode!
var basketballNode : BasketBallNode!
var cloudNode : CloudNode!
var dartNode : DartNode!
var dartNode2 : DartNode!
var shurikenNode : ShurikenNode!

class GameScene: SKScene , SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - ivars-
    var touchedNode : BalloonNode?
    var currentLevel:Int=1
    var startLocation:CGPoint?
    var startTime: NSTimeInterval?
    var SwipeSpeed: CGFloat?
    var isSwiped = false
    var swipeDirection = 0
    var totalBalloonNodes = 0
    var BalloonsFreed = 0
    var bolts = [BoltNode]()
    var didBalloonTouchRock = false
    
    //let bolt = SKSpriteNode(imageNamed: "bolt")
    var TimeNodeLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    var TimeLeftLabel = SKLabelNode(fontNamed: MyConstants.Font.MainFont)
    var time = 1000
    var MovedNodes = [SKNode]()
    var pathEmitter = SKEmitterNode(fileNamed: "MyParticle2")
    
    var gameLoopPaused : Bool = true {
        didSet{
            print("gameLoopPasued = \(gameLoopPaused)")
            if gameLoopPaused{
                runPauseAction()
            } else {
                runUnpauseAction()
            }
        }
    }
    
    //MARK: - Initialization -
    override func didMoveToView(view: SKView) {

        /* Setup your scene here */
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        let playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width, height: size.height-playableMargin*2)
        
        TimeNodeLabel.position = CGPoint(x:80, y: size.height - 60)
        TimeNodeLabel.fontColor = SKColor.blackColor()
        TimeNodeLabel.text = "Time : "
        addChild(TimeNodeLabel)
        
        TimeLeftLabel.position = CGPoint(x:160, y: size.height - 60)
        TimeLeftLabel.fontColor = SKColor.blackColor()
        TimeLeftLabel.text = "\(self.time)"
        addChild(TimeLeftLabel)
        
        //Setting up the physics body of Screen
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        enumerateChildNodesWithName("//*", usingBlock: {node, _ in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
            }
        })
        
        enumerateChildNodesWithName("//balloonBody", usingBlock: {node, _ in
            self.totalBalloonNodes++
        })

        // Making custom object nodes

        balloonNode = childNodeWithName("//balloonBody") as? BalloonNode
        rockNode = childNodeWithName("rockBody") as? RockNode
        spikeNode = childNodeWithName("spikeBody") as? SpikeNode
        basketballNode = childNodeWithName("basketballBody") as? BasketBallNode
        cloudNode = childNodeWithName("cloudBody") as? CloudNode
        dartNode = childNodeWithName("dartBody") as? DartNode
        dartNode2 = childNodeWithName("dartBody2") as? DartNode
        shurikenNode = childNodeWithName("shurikenBody") as? ShurikenNode
        
        //Used for Onboarding purposes
        enumerateChildNodesWithName("//TutorialLabel", usingBlock: {node, _ in
            //let tutorialLabel = childNodeWithName("TutorialLabel")
            let wait = SKAction.waitForDuration(3.0)
            let fadeAction = SKAction.fadeOutWithDuration(3.0)
            if self.currentLevel == 1 {
                node.runAction( wait)
                
                let finger = SKSpriteNode(imageNamed: "finger")
                finger.setScale(0.2)
                finger.zPosition = 2
                finger.position = CGPoint(x : self.size.width / 2 - 150 , y: self.size.height / 2 - 140)
                self.addChild(finger)
                
                let dotted = SKSpriteNode(imageNamed: "dotted2")
                dotted.setScale(0.25)
                dotted.position = CGPoint(x : self.size.width / 2 , y : self.size.height / 2 - 120)
                self.addChild(dotted)
                
                let MoveAction = SKAction.moveTo( CGPoint(x: self.size.width / 2 + 150 , y : self.size.height / 2 - 140), duration : 1.0 )
                let removeAction = SKAction.removeFromParent()
                let dotRemove = SKAction.runBlock(){ dotted.removeFromParent() }
                finger.runAction(SKAction.sequence([MoveAction,removeAction, dotRemove]))
                
                
                
            } else {
            node.runAction( SKAction.sequence([wait, fadeAction]))
            }
        })
        
        ThrowDart()
        ThrowBolt()
        
        // set up swipe gesture recognizer for up direction
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeDetectedUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeUp.delegate = self
        swipeUp.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeUp)

        
        // set up swipe gesture recognizer for left direction
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeDetectedLeft:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeft.delegate = self
        swipeLeft.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeft)


        
        // set up swipe gesture recognizer for right direction
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeDetectedRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.delegate = self
        swipeRight.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeRight)
        
        // set up swipe gesture recognizer for down direction
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDetectedDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeDown.delegate = self
        swipeDown.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeDown)
    }
   
    //MARK: - Helper -
    func didBeginContact(contact: SKPhysicsContact) {
       
        let tempBalloonNode : SKSpriteNode?
        if contact.bodyA.categoryBitMask == PhysicsCategory.Balloon {
            tempBalloonNode = contact.bodyA.node as? SKSpriteNode
        } else {
            tempBalloonNode = contact.bodyB.node as? SKSpriteNode
        }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
       
        if collision == PhysicsCategory.Balloon | PhysicsCategory.Rock {
            print(MyConstants.Collision.BalloonRock)
            rockNode?.runAction( SKAction.playSoundFileNamed("collision.wav", waitForCompletion: false))
            balloonNode.physicsBody?.applyImpulse( CGVectorMake(0.0, 0.0))
            balloonNode.removeActionForKey("MoveUpAction")
            // balloonNode.removeActionForKey("MoveLeftAction")
            // balloonNode.removeActionForKey("MoveRightAction")
             balloonNode.removeActionForKey("MoveDownAction")
            didBalloonTouchRock = true
         
        } else if collision == PhysicsCategory.Balloon | PhysicsCategory.Spike {
           
            print(MyConstants.Collision.BalloonSpike)
            LoseLevel(contact, node: tempBalloonNode!)
            //Setting up the pop image and pop sound
    
        } else if collision == PhysicsCategory.Balloon | PhysicsCategory.Basketball{
            
            print(MyConstants.Collision.BalloonBasketball)
            //Make the balloon respond to collision between basketballs
            balloonNode.physicsBody?.applyImpulse(contact.contactNormal * 28)
            
        } else if collision == PhysicsCategory.Balloon | PhysicsCategory.Bolt {
            print(MyConstants.Collision.BalloonBolt)
            LoseLevel(contact, node: tempBalloonNode!)
            
        } else if collision == PhysicsCategory.Balloon | PhysicsCategory.Dart {
            print(MyConstants.Collision.BalloonDart)
            LoseLevel(contact, node: tempBalloonNode!)
            
        } else if collision == PhysicsCategory.Balloon | PhysicsCategory.Shuriken {
            print(MyConstants.Collision.BalloonShuriken)
            LoseLevel(contact, node: tempBalloonNode!)
            
        } else if collision == PhysicsCategory.Balloon | PhysicsCategory.Edge {
            
            // tempBalloonNode?.removeActionForKey("MoveUpAction")
             tempBalloonNode?.removeActionForKey("MoveDownAction")
             tempBalloonNode?.removeActionForKey("MoveRightAction")
             tempBalloonNode?.removeActionForKey("MoveLeftAction")
            
            if tempBalloonNode?.position.y > 1100.0 {
           
            // Checking if collision is with top edge only. We increse the ballon freed count
            print(MyConstants.Collision.BalloonEdge)
             BalloonsFreed++
                tempBalloonNode?.runAction(
                    
                    // TODO:- Wait animation not working -
                    SKAction.sequence([
                   // SKAction.waitForDuration(1.0),
                    SKAction.scaleTo(0.0,duration: 1.0),
                    SKAction.removeFromParent()])
                )
                
            }
              tempBalloonNode?.runAction(SKAction.waitForDuration(1.0))
            //Checking if the total balloons are freed
             print("the total balloons are -  \(totalBalloonNodes)")
             print("the total balloons freed are -  \(BalloonsFreed)")
            if(BalloonsFreed == totalBalloonNodes){
                // Revealing the Game win screen
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true,currentLevel:currentLevel+1, time:time)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }

        }
    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
        //print("Contact Ended")
        //TODO:- Add impulse with Velocity
        // Applying an impulse on the balloon
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Balloon | PhysicsCategory.Rock {
        enumerateChildNodesWithName("//balloonBody", usingBlock: {node, _ in
            node.physicsBody!.applyImpulse(CGVector(dx:0,dy:120))
            self.didBalloonTouchRock = false
            })
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches Began")
    
        // Saving the touch location and timestamp. This is used to calcuate force of the swipe.
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        touchedNode = nodeAtPoint(touchLocation) as? BalloonNode
        let scaleUpAction = SKAction.scaleBy(1.4, duration: 0.15)
        let wait = SKAction.waitForDuration(0.15)
        let scaleDownAction = SKAction.scaleBy(0.7142, duration: 0.15)
        touchedNode?.runAction(SKAction.sequence([scaleUpAction,wait,scaleDownAction]))
        //touchedNode = nodeAtPoint(touchLocation)?
        startLocation = touchLocation
        startTime = touch.timestamp
    }
    
    //MARK: - UI Gestures -
    func swipeDetectedUp(sender:UISwipeGestureRecognizer){
        print("\(MyConstants.SwipeDirection.Up)\(SwipeSpeed)")
        isSwiped = true
        swipeDirection = 1 // Up
        self.pathEmitter?.removeFromParent()
        pathEmitter?.position = startLocation!
        //pathEmitter?.zRotation = 1.576
               pathEmitter?.zRotation = 1.576
        print("The z rotations is - \(pathEmitter?.zRotation)")
        addChild(pathEmitter!)

    }
    
    
    func swipeDetectedLeft(sender:UISwipeGestureRecognizer){
        print("\(MyConstants.SwipeDirection.Left)\(SwipeSpeed)")
        isSwiped = true
        swipeDirection = 2 // Left
        self.pathEmitter?.removeFromParent()
        pathEmitter?.position = startLocation!
         pathEmitter?.zRotation = 0
        addChild(pathEmitter!)
    }
    
    
    func swipeDetectedRight(sender:UISwipeGestureRecognizer){
        print("\(MyConstants.SwipeDirection.Right)\(SwipeSpeed)")
        isSwiped = true
        swipeDirection = 3 // Right
        self.pathEmitter?.removeFromParent()
        pathEmitter?.position = startLocation!
         pathEmitter?.zRotation = 0
        addChild(pathEmitter!)
    }
    
    func swipeDetectedDown(sender:UISwipeGestureRecognizer){
        print("\(MyConstants.SwipeDirection.Down)\(SwipeSpeed)")
        isSwiped = true
        swipeDirection = 4 // Right
        self.pathEmitter?.removeFromParent()
        pathEmitter?.position = startLocation!
        pathEmitter?.zRotation = 1.576
        addChild(pathEmitter!)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches moved")
        guard let touch = touches.first else {
            return
        }
        
      
        let touchLocation = touch.locationInNode(self)
         let endPoint = touch.previousLocationInNode(self)
        // check if balloon intersects
        scene?.physicsWorld.enumerateBodiesAlongRayStart(touchLocation, end: endPoint, usingBlock: { (body, point, normal, stop) -> Void in
            
            print("The balloon intersects with a swipe")
            //print(body.node!.name)
           // body.node!.runAction(SKAction.moveToX(body.node!.position.x + 100 , duration: 0.5))
            if  body.node != nil {
                if body.node!.name == "balloonBody" {
                    self.MovedNodes.append(body.node!)
                }
            }
           
        })
     
        pathEmitter?.position = touchLocation
               
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches Ebnded")
        self.pathEmitter?.removeFromParent()
        guard let touch = touches.first else {
            return
        }
         print(self.MovedNodes)
        if (self.MovedNodes.isEmpty) == true { return }
       // if touchedNode == nil { return }
        //Calcaulation of Force speed and the approx movement.
        let touchLocation = touch.locationInNode(self)
        //touchedNode = nodeAtPoint(touchLocation) as? BalloonNode
        let dx:CGFloat = touchLocation.x - startLocation!.x;
        let dy:CGFloat = touchLocation.y - startLocation!.y;
        let magnitude:CGFloat = sqrt(dx*dx+dy*dy)
        let dt:CGFloat = CGFloat(touch.timestamp - startTime!)
        SwipeSpeed = magnitude/dt
         print("\(MyConstants.SwipeDirection.SwipeEnd) \(swipeDirection) : \(SwipeSpeed)")
        var movePosition = SwipeSpeed! / 5
        print("The move Position - \(movePosition)")
        if movePosition < 300 {
            movePosition = 300
        }
        
        //Checking for Swipe Direction
        if(isSwiped == true)
        {
            switch swipeDirection{
            
            case 1: // Up
                for var i = 0 ; i < self.MovedNodes.count ; i++
                {
                    if didBalloonTouchRock == false {
                        
                        self.MovedNodes[i].removeActionForKey("MoveLeftAction")
                        self.MovedNodes[i].removeActionForKey("MoveRightAction")
                        
                      SKTAudio.sharedInstance().playSoundEffect("wind.mp3")
                        self.MovedNodes[i].runAction(SKAction.moveTo(CGPoint(x:  self.MovedNodes[i].position.x, y:  self.MovedNodes[i].position.y + (movePosition)), duration: 0.7), withKey:"MoveUpAction")
                    }
                }
                
            case 2: // Left

                    for var i = 0 ; i < self.MovedNodes.count ; i++
                    {
                        SKTAudio.sharedInstance().playSoundEffect("wind.mp3")
                        self.MovedNodes[i].runAction(SKAction.moveTo(CGPoint(x: self.MovedNodes[i].position.x - movePosition, y: self.MovedNodes[i].position.y), duration: 1.0), withKey:"MoveLeftAction")
                    }

            case 3: // Right
             
                for var i = 0 ; i < self.MovedNodes.count ; i++
                {
                SKTAudio.sharedInstance().playSoundEffect("wind.mp3")
                   // touchedNode!.runAction(sound)
                    self.MovedNodes[i].runAction(SKAction.moveTo(CGPoint(x: self.MovedNodes[i].position.x + movePosition, y: self.MovedNodes[i].position.y), duration: 1.0), withKey:"MoveRightAction")
                }

            case 4: // Down
                
                for var i = 0 ; i < self.MovedNodes.count ; i++
                {
                    SKTAudio.sharedInstance().playSoundEffect("wind.mp3")
                    // touchedNode!.runAction(sound)
                    self.MovedNodes[i].runAction(SKAction.moveTo(CGPoint(x: self.MovedNodes[i].position.x , y: self.MovedNodes[i].position.y - movePosition), duration: 1.0), withKey:"MoveDownAction")
                }

            default:break
            }
        }
        self.MovedNodes.removeAll()
    }
    
    //MARK: - Pausing Events -
    func runPauseAction(){
        scene?.alpha = 0.5
        physicsWorld.speed = 0.0
        self.view?.paused = true
    }
    
 
    func runUnpauseAction(){
        self.view?.paused = false
        physicsWorld.speed = 1.0
         scene?.alpha = 1.0
       // unPauseAction.timingMode = .EaseIn
    }

    func ThrowBolt(){
        if cloudNode == nil { return }
        
        cloudNode?.position = CGPoint(x : -cloudNode.size.width, y: self.size.height * 5 / 6)
        let bolt = BoltNode()
        bolt.setScale(0.0)
        bolt.zPosition = 1
        bolt.position = CGPoint(x: cloudNode.position.x , y: cloudNode.position.y)
        bolt.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
        bolt.physicsBody?.mass = 1.33
        bolt.physicsBody?.restitution = 1.0
        bolt.physicsBody?.linearDamping = 0.0
        bolt.physicsBody?.angularDamping = 0.0
        bolt.physicsBody?.angularVelocity = 0.0
        bolt.physicsBody?.friction = 0.0
        bolt.physicsBody?.categoryBitMask = 64
        bolt.physicsBody?.collisionBitMask = 1
        bolt.physicsBody?.contactTestBitMask = 1
        bolt.physicsBody?.affectedByGravity = false
        bolt.physicsBody?.dynamic = false
        bolts.append(bolt)
        self.addChild(bolt)
      
        cloudNode?.runAction( SKAction.playSoundFileNamed("thunder.wav", waitForCompletion: false))
        //Time Delay Code
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue())
        {
            self.runAction(SKAction.runBlock(){ self.throwBoltAgain(bolt)})
        }
    }
    
    func ThrowDart(){
        if dartNode == nil { return } else {
        dartNode.position = CGPoint(x: self.size.width + dartNode.size.width, y: size.height / 2)
        let DartMoveAction = SKAction.moveTo(CGPoint(x: -dartNode.size.width, y: self.size.height / 2), duration: 4.4)
        let DartYRotation = SKAction.rotateByAngle(3.1412, duration: 0.3)
        let DartReverseMoveAction = SKAction.moveTo(CGPoint(x: self.size.width + dartNode.size.width, y: self.size.height / 2), duration: 4.4)
        dartNode?.runAction(SKAction.repeatActionForever( SKAction.sequence([ DartMoveAction, DartYRotation, DartReverseMoveAction, DartYRotation])))
        }
        
        if dartNode2 == nil { return } else {
            dartNode2.position = CGPoint(x: -dartNode2.size.width, y: size.height * 4 / 5)
            let DartMoveAction = SKAction.moveTo(CGPoint(x: self.size.width + dartNode2.size.width, y: self.size.height * 4 / 5), duration: 2.0)
            let DartYRotation = SKAction.rotateByAngle(3.1412, duration: 0.3)
            let DartReverseMoveAction = SKAction.moveTo(CGPoint(x: -dartNode2.size.width, y: self.size.height * 4 / 5), duration: 2.0)
            dartNode2?.runAction(SKAction.repeatActionForever( SKAction.sequence([ DartMoveAction, DartYRotation, DartReverseMoveAction, DartYRotation])))
        }

    }
    
    override func didSimulatePhysics() {
        self.time--
        TimeLeftLabel.text = "\(self.time)"
        if self.time == 0 {
            //Revealing the Game lose screen
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, currentLevel:currentLevel )
            //Time Delay Code
            self.view?.presentScene(gameOverScene, transition: reveal)
           
        }
        if balloonNode.position.x < -1024.0 {
           balloonNode.position.x = -1024.0 //playableRect.minX
        }
        if balloonNode.position.x > 1024.0 {
            balloonNode.position.x = 1024.0//playableRect.maxX
        }
        if rockNode != nil {
            if balloonNode.position.y > rockNode.position.y {
                if balloonNode.position.x > rockNode.position.x - 50 && balloonNode.position.x < rockNode.position.x + 50 {
             //   balloonNode.position.y = rockNode.position.y
                }
            }
        }
    }
    
    func LoseLevel(contact: SKPhysicsContact, node : SKSpriteNode){
        
        let balloonPop = SKSpriteNode(imageNamed:"BalloonPop")
        balloonPop.setScale(0)
        balloonPop.zPosition = 3
        balloonPop.position = contact.contactPoint
        addChild(balloonPop)
        let appear = SKAction.scaleTo(0.5,	duration: 0.5)
        let wait = SKAction.waitForDuration(1.0)
        let sound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
        balloonPop.runAction(SKAction.sequence([ appear,sound, wait]))
        node.runAction(SKAction.scaleTo(0.0, duration: 1.0))
        
        //Revealing the Game lose screen
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let gameOverScene = GameOverScene(size: self.size, won: false, currentLevel:currentLevel )
        //Time Delay Code
        let delay = 0.7 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue())
            {
                self.view?.presentScene(gameOverScene, transition: reveal)
        }
 
    }
    
    func throwBoltAgain(bolt : BoltNode){
  
       // SKTAudio.sharedInstance().playSoundEffect("thunder.wav")
       // let audio = SKTAudio()
       // audio.playSoundEffect("thunder.wav")
       
        
                cloudNode?.position = CGPoint(x : -cloudNode.size.width, y: self.size.height * 5 / 6)
                //self.addChild(bolt)
                let moveAction = SKAction.moveTo(CGPoint(x: balloonNode.position.x + 512 , y: self.size.height * 5/6), duration: 1.0)
                let CloudInitialMoveAction = SKAction.moveTo(CGPoint(x: balloonNode.position.x + 532 , y: self.size.height * 5/6), duration: 1.0)
                cloudNode?.runAction( SKAction.sequence([ CloudInitialMoveAction]))
                let appearAction = SKAction.scaleTo(0.03, duration: 0.5)
                let dropAction = SKAction.moveTo(CGPoint(x: balloonNode.position.x + 512 , y: -self.size.height), duration: 4.0)
                let removeFromArrayAction = SKAction.runBlock(){ self.bolts.removeAtIndex(self.bolts.indexOf(bolt)!) }
                let removeAction = SKAction.removeFromParent()
                bolt.runAction(SKAction.sequence([moveAction,appearAction,dropAction,removeFromArrayAction, removeAction]))
                let PositionAction = SKAction.runBlock(){ cloudNode?.position = CGPoint(x : -cloudNode.size.width, y: self.size.height * 5 / 6)}
                let CloudMoveAction = SKAction.moveTo(CGPoint(x: self.size.width + cloudNode.size.width, y: self.size.height * 5/6), duration: 2.0)
                // let CloudReverseMoveAction = SKAction.moveTo(CGPoint(x: -cloudNode.size.width, y: self.size.height * 5/6), duration: 2.0)
                cloudNode?.runAction(SKAction.sequence([ CloudMoveAction,PositionAction]))
    }
    
    // Used to switch between the levels.
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .AspectFill
        return scene
    }
    
    
}
