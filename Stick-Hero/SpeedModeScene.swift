//
//  SpeedModeScene.swift
//  Stick-Hero
//
//  Created by 刘嘉诚 on 11/12/15.
//  Copyright © 2015 koofrank. All rights reserved.
//


//timing
//timing and end/retry
//score
//faster

import SpriteKit
import SwiftHTTP
import JSONJoy
/*




@IBAction func CountDownBegin(sender: UIButton) {
display.text="60"
remainingSeconds = 60
isCounting = !isCounting
}




*/
class SpeedModeScene: SKScene, SKPhysicsContactDelegate {
    var gameOver = false {
        willSet {
            if (newValue) {
                isCounting = false
                checkHighScoreAndStore()
                let gameOverLayer = childNodeWithName(SpeedModeSceneChildName.GameOverLayerName.rawValue) as SKNode?
                gameOverLayer?.runAction(SKAction.moveDistance(CGVectorMake(0, 100), fadeInWithDuration: 0.2))
            }
            
        }
    }
    
    let StackHeight:CGFloat = 400.0
    let StackMaxWidth:CGFloat = 300.0
    let StackMinWidth:CGFloat = 100.0
    let gravity:CGFloat = -100.0
    let StackGapMinWidth:Int = 80
    var HeroSpeed:CGFloat = 600
    
    let StoreScoreName = "com.SpeedMode.score"
    
    var Character = ""
    
    var touchCounter:Double = 0
    var isFirstTouch = false
    var isBegin = false
    var isEnd = false
    var leftStack:SKShapeNode?
    var rightStack:SKShapeNode?
    
    var nextLeftStartX:CGFloat = 0
    var stickHeight:CGFloat = 0
    
    var score:Int = 0 {
        willSet {
            let scoreBand = childNodeWithName(SpeedModeSceneChildName.ScoreName.rawValue) as? SKLabelNode
            scoreBand?.text = "\(newValue)"
            scoreBand?.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)]))
            
            if (newValue == 1) {
                let tip = childNodeWithName(SpeedModeSceneChildName.TipName.rawValue) as? SKLabelNode
                tip?.runAction(SKAction.fadeAlphaTo(0, duration: 0.4))
            }
        }
    }
    
    var timer: NSTimer?
    var remainingSeconds: Int = 30{
        willSet(newSeconds){
            let timingBand = childNodeWithName(SpeedModeSceneChildName.TimerName.rawValue) as? SKLabelNode
            timingBand!.text = "\(newSeconds)"
        }
    }
    
    var isCounting:Bool = false {
        willSet(newValue){
            if newValue{
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            }else{
                timer?.invalidate()
                timer = nil
            }
            
            
        }
    }
    
    func updateTimer(timer: NSTimer?){
        remainingSeconds -= 1
        if remainingSeconds <= 0{
            isCounting = false
            gameOver = true
            let alert = UIAlertView()
            alert.title = "Time's Up"
            alert.message = ""
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    lazy var playAbleRect:CGRect = {
        let maxAspectRatio:CGFloat = 16.0/9.0 // iPhone 5"
        let maxAspectRatioWidth = self.size.height / maxAspectRatio
        let playableMargin = (self.size.width - maxAspectRatioWidth) / 2.0
        return CGRectMake(playableMargin, 0, maxAspectRatioWidth, self.size.height)
    }()
    
    lazy var walkAction:SKAction = {
        var textures:[SKTexture] = []
        switch self.Character{
        case "DY#1":
            for i in 0...1 {
                let texture = SKTexture(imageNamed: "human\(i + 1).png")
                textures.append(texture)
            }
        case "DY#2":
            for i in 0...1 {
                let texture = SKTexture(imageNamed: "wdy_shoulder\(i + 1).png")
                textures.append(texture)
            }
        case "DY#3":
            for i in 0...1 {
                let texture = SKTexture(imageNamed: "wdy_thin\(i + 1).png")
                textures.append(texture)
            }
        default:
            for i in 0...1 {
                let texture = SKTexture(imageNamed: "human\(i + 1).png")
                textures.append(texture)
            }
        }
        
        let action = SKAction.animateWithTextures(textures, timePerFrame: 0.15, resize: true, restore: true)
        
        return SKAction.repeatActionForever(action)
    }()
    
    //MARK: - override
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPointMake(0.5, 0.5)
        physicsWorld.contactDelegate = self
    }
    
    override func didMoveToView(view: SKView) {
        start()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard !gameOver else {
            let gameOverLayer = childNodeWithName(SpeedModeSceneChildName.GameOverLayerName.rawValue) as SKNode?
            
            let location = touches.first?.locationInNode(gameOverLayer!)
            let retry = gameOverLayer!.nodeAtPoint(location!)
            
            
            if (retry.name == SpeedModeSceneChildName.RetryButtonName.rawValue) {
                retry.runAction(SKAction.sequence([SKAction.setTexture(SKTexture(imageNamed: "button_retry_down"), resize: false), SKAction.waitForDuration(0.3)]), completion: {[unowned self] () -> Void in
                    self.restart()
                    })
            }
            return
        }
        
        if !isBegin && !isEnd {
            isBegin = true
            touchCounter += 1
            
            if touchCounter == 1 {
                isFirstTouch = true
                isCounting = true
                
            }else{
                isFirstTouch = false
                HeroSpeed = HeroSpeed + 100
            }
            
            let stick = loadStick()
            let hero = childNodeWithName(SpeedModeSceneChildName.HeroName.rawValue) as! SKSpriteNode
            
            let action = SKAction.resizeToHeight(CGFloat(DefinedScreenHeight - StackHeight), duration: max(1.5 - (touchCounter-1) * 0.2 ,0.3))
            stick.runAction(action, withKey:SpeedModeSceneActionKey.StickGrowAction.rawValue)
            
            let scaleAction = SKAction.sequence([SKAction.scaleYTo(0.9, duration: 0.05), SKAction.scaleYTo(1, duration: 0.05)])
            let loopAction = SKAction.group([SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.StickGrowAudioName.rawValue, waitForCompletion: true)])
            stick.runAction(SKAction.repeatActionForever(loopAction), withKey: SpeedModeSceneActionKey.StickGrowAudioAction.rawValue)
            hero.runAction(SKAction.repeatActionForever(scaleAction), withKey: SpeedModeSceneActionKey.HeroScaleAction.rawValue)
            
            return
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isBegin && !isEnd {
            isEnd  = true
            
            let hero = childNodeWithName(SpeedModeSceneChildName.HeroName.rawValue) as! SKSpriteNode
            hero.removeActionForKey(SpeedModeSceneActionKey.HeroScaleAction.rawValue)
            hero.runAction(SKAction.scaleYTo(1, duration: 0.04))
            
            let stick = childNodeWithName(SpeedModeSceneChildName.StickName.rawValue) as! SKSpriteNode
            stick.removeActionForKey(SpeedModeSceneActionKey.StickGrowAction.rawValue)
            stick.removeActionForKey(SpeedModeSceneActionKey.StickGrowAudioAction.rawValue)
            stick.runAction(SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.StickGrowOverAudioName.rawValue, waitForCompletion: false))
            
            stickHeight = stick.size.height;
            
            let action = SKAction.rotateToAngle(CGFloat(-M_PI / 2), duration: 0.4, shortestUnitArc: true)
            let playFall = SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.StickFallAudioName.rawValue, waitForCompletion: false)
            
            stick.runAction(SKAction.sequence([SKAction.waitForDuration(0.2), action, playFall]), completion: {[unowned self] () -> Void in
                self.heroGo(self.checkPass())
                })
        }
    }
    
    func start() {
        
        loadBackground()
        loadScoreBackground()
        loadScore()
        loadTip()
        loadGameOverLayer()
        loadTimer()
        leftStack = loadStacks(false, startLeftPoint: playAbleRect.origin.x)
        self.removeMidTouch(false, left:true)
        loadHero()
        
        let maxGap = Int(playAbleRect.width - StackMaxWidth - (leftStack?.frame.size.width)!)
        let gap = CGFloat(randomInRange(StackGapMinWidth...maxGap))
        rightStack = loadStacks(false, startLeftPoint: nextLeftStartX + gap)
        
        gameOver = false
    }
    
    func restart() {
        //记录分数
        isBegin = false
        isEnd = false
        isCounting = false
        isFirstTouch = false
        touchCounter = 0
        score = 0
        remainingSeconds = 30
        nextLeftStartX = 0
        HeroSpeed = 650
        removeAllChildren()
        start()
    }
    
    private func checkPass() -> Bool {
        let stick = childNodeWithName(SpeedModeSceneChildName.StickName.rawValue) as! SKSpriteNode
        
        let rightPoint = DefinedScreenWidth / 2 + stick.position.x + self.stickHeight
        
        guard rightPoint < self.nextLeftStartX else {
            return false
        }
        
        guard (CGRectIntersectsRect((leftStack?.frame)!, stick.frame) && CGRectIntersectsRect((rightStack?.frame)!, stick.frame)) else {
            return false
        }
        
        self.checkTouchMidStack()
        
        return true
    }
    
    private func checkTouchMidStack() {
        let stick = childNodeWithName(SpeedModeSceneChildName.StickName.rawValue) as! SKSpriteNode
        let stackMid = rightStack!.childNodeWithName(SpeedModeSceneChildName.StackMidName.rawValue) as! SKShapeNode
        
        let newPoint = stackMid.convertPoint(CGPointMake(-10, 10), toNode: self)
        
        if ((stick.position.x + self.stickHeight) >= newPoint.x  && (stick.position.x + self.stickHeight) <= newPoint.x + 20) {
            loadPerfect()
            self.runAction(SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.StickTouchMidAudioName.rawValue, waitForCompletion: false))
            score++
        }
        
    }
    
    private func removeMidTouch(animate:Bool, left:Bool) {
        let stack = left ? leftStack : rightStack
        let mid = stack!.childNodeWithName(SpeedModeSceneChildName.StackMidName.rawValue) as! SKShapeNode
        if (animate) {
            mid.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
        }
        else {
            mid.removeFromParent()
        }
    }
    
    private func heroGo(pass:Bool) {
        let hero = childNodeWithName(SpeedModeSceneChildName.HeroName.rawValue) as! SKSpriteNode
        
        guard pass else {
            let stick = childNodeWithName(SpeedModeSceneChildName.StickName.rawValue) as! SKSpriteNode
            
            let dis:CGFloat = stick.position.x + self.stickHeight
            let disGap = nextLeftStartX - (DefinedScreenWidth / 2 - abs(hero.position.x)) - (rightStack?.frame.size.width)! / 2
            
            let move = SKAction.moveToX(dis, duration: NSTimeInterval(abs(disGap / HeroSpeed)))
            
            hero.runAction(walkAction, withKey: SpeedModeSceneActionKey.WalkAction.rawValue)
            hero.runAction(move, completion: {[unowned self] () -> Void in
                stick.runAction(SKAction.rotateToAngle(CGFloat(-M_PI), duration: 0.4))
                
                hero.physicsBody!.affectedByGravity = true
                hero.runAction(SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.DeadAudioName.rawValue, waitForCompletion: false))
                hero.removeActionForKey(SpeedModeSceneActionKey.WalkAction.rawValue)
                self.runAction(SKAction.waitForDuration(0.5), completion: {[unowned self] () -> Void in
                    self.gameOver = true
                    })
                })
            
            return
        }
        
        let dis:CGFloat = -DefinedScreenWidth / 2 + nextLeftStartX - hero.size.width / 2 - 20
        let disGap = nextLeftStartX - (DefinedScreenWidth / 2 - abs(hero.position.x)) - (rightStack?.frame.size.width)! / 2
        
        let move = SKAction.moveToX(dis, duration: NSTimeInterval(abs(disGap / HeroSpeed)))
        
        hero.runAction(walkAction, withKey: SpeedModeSceneActionKey.WalkAction.rawValue)
        hero.runAction(move) { [unowned self]() -> Void in
            self.score++
            
            hero.runAction(SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.VictoryAudioName.rawValue, waitForCompletion: false))
            hero.removeActionForKey(SpeedModeSceneActionKey.WalkAction.rawValue)
            self.moveStackAndCreateNew()
        }
    }
    
    private func checkHighScoreAndStore() {
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey(StoreScoreName)
        if (score > Int(highScore)) {
            showHighScore()
            
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: StoreScoreName)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    private func showHighScore() {
        self.runAction(SKAction.playSoundFileNamed(SpeedModeSceneEffectAudioName.HighScoreAudioName.rawValue, waitForCompletion: false))
        
        let wait = SKAction.waitForDuration(0.4)
        let grow = SKAction.scaleTo(1.5, duration: 0.4)
        grow.timingMode = .EaseInEaseOut
        let explosion = starEmitterActionAtPosition(CGPointMake(0, 300))
        let shrink = SKAction.scaleTo(1, duration: 0.2)
        
        let idleGrow = SKAction.scaleTo(1.2, duration: 0.4)
        idleGrow.timingMode = .EaseInEaseOut
        let idleShrink = SKAction.scaleTo(1, duration: 0.4)
        let pulsate = SKAction.repeatActionForever(SKAction.sequence([idleGrow, idleShrink]))
        
        let gameOverLayer = childNodeWithName(SpeedModeSceneChildName.GameOverLayerName.rawValue) as SKNode?
        let highScoreLabel = gameOverLayer?.childNodeWithName(SpeedModeSceneChildName.HighScoreName.rawValue) as SKNode?
        highScoreLabel?.runAction(SKAction.sequence([wait, explosion, grow, shrink]), completion: { () -> Void in
            highScoreLabel?.runAction(pulsate)
        })
    }
    
    private func moveStackAndCreateNew() {
        let action = SKAction.moveBy(CGVectorMake(-nextLeftStartX + (rightStack?.frame.size.width)! + playAbleRect.origin.x - 2, 0), duration: 0.3)
        rightStack?.runAction(action)
        self.removeMidTouch(true, left:false)
        
        let hero = childNodeWithName(SpeedModeSceneChildName.HeroName.rawValue) as! SKSpriteNode
        let stick = childNodeWithName(SpeedModeSceneChildName.StickName.rawValue) as! SKSpriteNode
        
        hero.runAction(action)
        stick.runAction(SKAction.group([SKAction.moveBy(CGVectorMake(-DefinedScreenWidth, 0), duration: 0.5), SKAction.fadeAlphaTo(0, duration: 0.3)])) { () -> Void in
            stick.removeFromParent()
        }
        
        leftStack?.runAction(SKAction.moveBy(CGVectorMake(-DefinedScreenWidth, 0), duration: 0.5), completion: {[unowned self] () -> Void in
            self.leftStack?.removeFromParent()
            
            let maxGap = Int(self.playAbleRect.width - (self.rightStack?.frame.size.width)! - self.StackMaxWidth)
            let gap = CGFloat(randomInRange(self.StackGapMinWidth...maxGap))
            
            self.leftStack = self.rightStack
            self.rightStack = self.loadStacks(true, startLeftPoint:self.playAbleRect.origin.x + (self.rightStack?.frame.size.width)! + gap)
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - load node
private extension SpeedModeScene {
    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let texture = SKTexture(image: UIImage(named: "stick_background.jpg")!)
            let node = SKSpriteNode(texture: texture)
            node.size = texture.size()
            node.zPosition = SpeedModeSceneZposition.BackgroundZposition.rawValue
            self.physicsWorld.gravity = CGVectorMake(0, gravity)
            
            addChild(node)
            return
        }
    }
    
    func loadScore() {
        let scoreBand = SKLabelNode(fontNamed: "Arial")
        scoreBand.name = SpeedModeSceneChildName.ScoreName.rawValue
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey(StoreScoreName)
        scoreBand.text = "HighScore:"+String(highScore)
        scoreBand.position = CGPointMake(0, DefinedScreenHeight / 2 - 200)
        scoreBand.fontColor = SKColor.whiteColor()
        scoreBand.fontSize = 100
        scoreBand.zPosition = SpeedModeSceneZposition.ScoreZposition.rawValue
        scoreBand.horizontalAlignmentMode = .Center
        
        addChild(scoreBand)
    }
    
    func loadTimer(){
        let timingBand = SKLabelNode(fontNamed: "Arial")
        timingBand.name = SpeedModeSceneChildName.TimerName.rawValue
        timingBand.text = "30"
        timingBand.position = CGPointMake(0, DefinedScreenHeight / 2 - 1400)
        timingBand.fontColor = SKColor.blueColor()
        timingBand.fontSize = 120
        timingBand.zPosition = SpeedModeSceneZposition.TimerZposition.rawValue
        timingBand.horizontalAlignmentMode = .Center
        
        addChild(timingBand)
    }
    
    func loadScoreBackground() {
        let back = SKShapeNode(rect: CGRectMake(-360, 794, 720, 140), cornerRadius: 20)
        back.zPosition = SpeedModeSceneZposition.ScoreBackgroundZposition.rawValue
        back.fillColor = SKColor.blackColor().colorWithAlphaComponent(0.3)
        back.strokeColor = SKColor.blackColor().colorWithAlphaComponent(0.3)
        addChild(back)
    }
    
    func loadHero() {
        var hero = SKSpriteNode(imageNamed: "human1")
        switch Character{
        case "DY#1":
            hero = SKSpriteNode(imageNamed: "human1")
        case "DY#2":
            hero = SKSpriteNode(imageNamed: "wdy_shoulder1")
        case "DY#3":
            hero = SKSpriteNode(imageNamed: "wdy_thin1")
        default:
            break
        }
        hero.name = SpeedModeSceneChildName.HeroName.rawValue
        hero.position = CGPointMake(-DefinedScreenWidth / 2 + nextLeftStartX - hero.size.width / 2 - 20, -DefinedScreenHeight / 2 + StackHeight + hero.size.height / 2 - 4)
        hero.zPosition = SpeedModeSceneZposition.HeroZposition.rawValue
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 18))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.allowsRotation = false
        
        addChild(hero)
    }
    
    func loadTip() {
        let tip = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        tip.name = SpeedModeSceneChildName.TipName.rawValue
        tip.text = "将手放在屏幕使竿变长"
        tip.position = CGPointMake(0, DefinedScreenHeight / 2 - 350)
        tip.fontColor = SKColor.blackColor()
        tip.fontSize = 52
        tip.zPosition = SpeedModeSceneZposition.TipZposition.rawValue
        tip.horizontalAlignmentMode = .Center
        
        addChild(tip)
    }
    
    func loadPerfect() {
        defer {
            let perfect = childNodeWithName(SpeedModeSceneChildName.PerfectName.rawValue) as! SKLabelNode?
            let sequence = SKAction.sequence([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.fadeAlphaTo(0, duration: 0.3)])
            let scale = SKAction.sequence([SKAction.scaleTo(1.4, duration: 0.3), SKAction.scaleTo(1, duration: 0.3)])
            perfect!.runAction(SKAction.group([sequence, scale]))
        }
        
        guard let _ = childNodeWithName(SpeedModeSceneChildName.PerfectName.rawValue) as! SKLabelNode? else {
            let perfect = SKLabelNode(fontNamed: "Arial")
            perfect.text = "Perfect +1"
            perfect.name = SpeedModeSceneChildName.PerfectName.rawValue
            perfect.position = CGPointMake(0, -100)
            perfect.fontColor = SKColor.blackColor()
            perfect.fontSize = 50
            perfect.zPosition = SpeedModeSceneZposition.PerfectZposition.rawValue
            perfect.horizontalAlignmentMode = .Center
            perfect.alpha = 0
            
            addChild(perfect)
            
            return
        }
        
    }
    
    func loadStick() -> SKSpriteNode {
        let hero = childNodeWithName(SpeedModeSceneChildName.HeroName.rawValue) as! SKSpriteNode
        
        let stick = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(12, 1))
        stick.zPosition = SpeedModeSceneZposition.StickZposition.rawValue
        stick.name = SpeedModeSceneChildName.StickName.rawValue
        stick.anchorPoint = CGPointMake(0.5, 0);
        stick.position = CGPointMake(hero.position.x + hero.size.width / 2 + 18, hero.position.y - hero.size.height / 2)
        addChild(stick)
        
        return stick
    }
    
    func loadStacks(animate: Bool, startLeftPoint: CGFloat) -> SKShapeNode {
        let max:Int = Int(StackMaxWidth / 10)
        let min:Int = Int(StackMinWidth / 10)
        let width:CGFloat = CGFloat(randomInRange(min...max) * 10)
        let height:CGFloat = StackHeight
        let stack = SKShapeNode(rectOfSize: CGSizeMake(width, height))
        stack.fillColor = SKColor.whiteColor()
        stack.strokeColor = SKColor.blackColor()
        stack.fillTexture = SKTexture(imageNamed: "wdy.png");
        stack.zPosition = SpeedModeSceneZposition.StackZposition.rawValue
        stack.name = SpeedModeSceneChildName.StackName.rawValue
        
        if (animate) {
            stack.position = CGPointMake(DefinedScreenWidth / 2, -DefinedScreenHeight / 2 + height / 2)
            
            stack.runAction(SKAction.moveToX(-DefinedScreenWidth / 2 + width / 2 + startLeftPoint, duration: 0.3), completion: {[unowned self] () -> Void in
                self.isBegin = false
                self.isEnd = false
                })
            
        }
        else {
            stack.position = CGPointMake(-DefinedScreenWidth / 2 + width / 2 + startLeftPoint, -DefinedScreenHeight / 2 + height / 2)
        }
        addChild(stack)
        
        let mid = SKShapeNode(rectOfSize: CGSizeMake(20, 20))
        mid.fillColor = SKColor.redColor()
        mid.strokeColor = SKColor.redColor()
        mid.zPosition = SpeedModeSceneZposition.StackMidZposition.rawValue
        mid.name = SpeedModeSceneChildName.StackMidName.rawValue
        mid.position = CGPointMake(0, height / 2 - 20 / 2)
        stack.addChild(mid)
        
        nextLeftStartX = width + startLeftPoint
        
        return stack
    }
    
    func loadGameOverLayer() {
        let node = SKNode()
        node.alpha = 0
        node.name = SpeedModeSceneChildName.GameOverLayerName.rawValue
        node.zPosition = SpeedModeSceneZposition.GameOverZposition.rawValue
        addChild(node)
        
        let label = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        label.text = "Game Over"
        label.fontColor = SKColor.redColor()
        label.fontSize = 150
        label.position = CGPointMake(0, 100)
        label.horizontalAlignmentMode = .Center
        node.addChild(label)
        
        let retry = SKSpriteNode(imageNamed: "button_retry_up")
        retry.name = SpeedModeSceneChildName.RetryButtonName.rawValue
        retry.position = CGPointMake(0, -200)
        node.addChild(retry)
        
        let highScore = SKLabelNode(fontNamed: "AmericanTypewriter")
        highScore.text = "Highscore!"
        highScore.fontColor = UIColor.whiteColor()
        highScore.fontSize = 50
        highScore.name = SpeedModeSceneChildName.HighScoreName.rawValue
        highScore.position = CGPointMake(0, 300)
        highScore.horizontalAlignmentMode = .Center
        highScore.setScale(0)
        node.addChild(highScore)
    }
    
    //MARK: - Action
    func starEmitterActionAtPosition(position: CGPoint) -> SKAction {
        let emitter = SKEmitterNode(fileNamed: "StarExplosion")
        emitter?.position = position
        emitter?.zPosition = SpeedModeSceneZposition.EmitterZposition.rawValue
        emitter?.alpha = 0.6
        addChild((emitter)!)
        
        let wait = SKAction.waitForDuration(0.15)
        
        return SKAction.runBlock({ () -> Void in
            emitter?.runAction(wait)
        })
    }
    
}
