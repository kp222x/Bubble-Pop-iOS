//
//  GameScene.swift
//  Bubble Pop
//
//  Created by Karan Parikh
//  Copyright © 2017 Karan Parikh. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

var gameScore = 0
var playingUser:String = ""
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //intialization
    let defaults = UserDefaults()
    let bubblePopSound = SKAction.playSoundFileNamed("popSound.wav", waitForCompletion: false)

    var seconds = 0
    var bubbleSpeed = 0.0
    
    var timerisOn = false
    let scoreLable = SKLabelNode(fontNamed: "Balloony-Regular")
    let timerLable = SKLabelNode(fontNamed: "Balloony-Regular")
    let tapToStartLable = SKLabelNode(fontNamed: "Balloony-Regular")
    
    var nodeCount = 0.0
    var maxBubbles = 15.0
    var redColor = 0
    var pinkColor = 0
    var greenColor = 0
    var blueColor = 0
    var blackColor = 0
    var redflag = false
    var pinkflag = false
    var greenflag = false
    var blueflag = false
    var blackflag = false
    
    var redCount = 0
    var pinkCount = 0
    var greenCount = 0
    var blueCount = 0
    var blackCount = 0
    var spawnNumber = 0
    
    enum gameState{
    
        case preGame //when the game state is before the start of the game
        case inGame  //when the game state is during the game
        case afterGame //when the game state is after the game
    }
    
    var currentGameState = gameState.preGame
    
    //function for generating random numbers
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    //building a game area
    var gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //run on startup
    override func didMove(to view: SKView) {
        
        //adding background
        
        gameScore = 0
        
        if(defaults.string(forKey: "time") != nil){
            seconds = Int(defaults.string(forKey: "time")!)!
        }else{
            seconds = 60
        }
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "underwater")
        background.size.height = self.size.height
        background.size.width = self.size.height * 8 / 5
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //adding score lable
        scoreLable.text = "SCORE: 0"
        scoreLable.fontSize = 100
        scoreLable.fontColor =  SKColor.white
        scoreLable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        scoreLable.position = CGPoint(x: self.size.width/2 , y: self.size.height + scoreLable.frame.size.height)
        scoreLable.zPosition = 100
        self.addChild(scoreLable)
        
        //adding timer
        timerLable.text = "\(seconds)"
        timerLable.fontSize = 100
        timerLable.fontColor =  SKColor.white
        timerLable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        timerLable.position = CGPoint(x: self.size.width/1.9 , y: self.size.height + timerLable.frame.size.height)
        timerLable.zPosition = 100
        self.addChild(timerLable)
        
        let timerMoveToScreenAction = SKAction.moveTo(y: self.size.height * 0.05, duration: 0.3)
        timerLable.run(timerMoveToScreenAction)
        let scoreMoveToScreenAction = SKAction.moveTo(y: self.size.height * 0.95, duration: 0.3)
        scoreLable.run(scoreMoveToScreenAction)
        
        
        //adding tap to begin
        tapToStartLable.text = "TAP TO BEGIN"
        tapToStartLable.fontSize = 100
        tapToStartLable.fontColor =  SKColor.white
        tapToStartLable.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        tapToStartLable.zPosition = 1
        tapToStartLable.alpha = 0
        self.addChild(tapToStartLable)
        
        let fadInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLable.run(fadInAction)
        
        //possibilities fot spawning bubbles
        redColor =  Int(maxBubbles * 0.45)
        pinkColor = Int(maxBubbles * 0.30)
        greenColor = Int(maxBubbles * 0.15)
        blueColor = Int(maxBubbles * 0.10)
        blackColor = Int(maxBubbles * 0.05)
        
    }
    
    
    func startGame() {
    
        currentGameState = gameState.inGame
        
        let fadOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadOutAction, deleteAction])
        tapToStartLable.run(deleteSequence)
        
        startNewLevel()
        startTimer()
    
    }
    
    
    //different levels for game specified here
    func startNewLevel(){
        
        if(defaults.string(forKey: "speed") == "min"){
            bubbleSpeed = 1
        }else if(defaults.string(forKey: "speed") == "med"){
            bubbleSpeed = 0.8
        }else{
            bubbleSpeed = 0.4
        }

        let spawn = SKAction.run(possibleBubble)
        let waitToSpawn = SKAction.wait(forDuration: bubbleSpeed, withRange: 0.2)
        let spawnSequence = SKAction.sequence([spawn , waitToSpawn])
        let spawnForever =  SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    
    
    
    //gameover function
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "red"){
            red, stop in
            red.removeAllActions()
        }
        self.enumerateChildNodes(withName: "pink"){
            pink, stop in
            pink.removeAllActions()
        }
        self.enumerateChildNodes(withName: "green"){
            green, stop in
            green.removeAllActions()
        }
        self.enumerateChildNodes(withName: "blue"){
            blue, stop in
            blue.removeAllActions()
        }
        self.enumerateChildNodes(withName: "black"){
            black, stop in
            black.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene =  SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction ])
        self.run(changeSceneSequence)
    }
    
    
    //change scene function
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    //starting game timer
    func startTimer(){
        
        if(timerisOn == false){
            Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(self.updateTimer),
                                 userInfo: nil,
                                 repeats: true)
        }
    }
    
    //updating game timer with decreasing one second
    func updateTimer(){
        
        seconds -= 1
        
        if(seconds == 0){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            runGameOver()            
        }
        
        if seconds >= 0 {
            timerLable.text = "\(seconds)"

        }
    }
    
    
    //scaleup/down function for score
    func scaleUpDown(){
        
        let scalUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequece =  SKAction.sequence([scalUp, scaleDown])
        scoreLable.run(scaleSequece)
        
    }
    
    //adding score according to bubble points
    func addScore(color: NSString){
        
        let color = color
        
        if(color == "red"){
            
            if(redflag == true){
                gameScore += Int(1*1.5)
                scoreLable.text = "SCORE: \(gameScore)"
                scaleUpDown()
            }else{
                gameScore += 1
                scoreLable.text = "SCORE: \(gameScore)"
                redflag = true
                pinkflag = false
                greenflag = false
                blueflag = false
                blackflag = false
            }
        }
        
        if(color == "pink"){
            
            if(pinkflag == true){
                gameScore += Int(2*1.5)
                scoreLable.text = "SCORE: \(gameScore)"
                scaleUpDown()
            }else{
                gameScore += 2
                scoreLable.text = "SCORE: \(gameScore)"
                redflag = false
                pinkflag = true
                greenflag = false
                blueflag = false
                blackflag = false
            }
        }
        
        if(color == "green"){
            
            if(greenflag == true){
                gameScore += Int(5*1.5)
                scoreLable.text = "SCORE: \(gameScore)"
                scaleUpDown()
            }else{
                gameScore += 5
                scoreLable.text = "SCORE: \(gameScore)"
                redflag = false
                pinkflag = false
                greenflag = true
                blueflag = false
                blackflag = false
            }
        }
        
        if(color == "blue"){
            
            if(blueflag == true){
                gameScore += Int(8*1.5)
                scoreLable.text = "SCORE: \(gameScore)"
                scaleUpDown()
            }else{
                gameScore += 8
                scoreLable.text = "SCORE: \(gameScore)"
                redflag = false
                pinkflag = false
                greenflag = false
                blueflag = true
                blackflag = false
            }
        }
        
        if(color == "black"){
            
            if(blackflag == true){
                gameScore += Int(10*1.5)
                scoreLable.text = "SCORE: \(gameScore)"
                scaleUpDown()
            }else{
                gameScore += 10
                scoreLable.text = "SCORE: \(gameScore)"
                redflag = false
                pinkflag = false
                greenflag = false
                blueflag = false
                blackflag = true
            }
        }
        
    }
    
    
    //spawning bubbles based on posibility
    func possibleBubble(){
        
        spawnNumber = Int(random(min: 1 , max: 21))
        
        let randomNumber = spawnNumber
        switch(randomNumber) {
        case 1..<9:
            if(redCount <= redColor){
                redCount += 1
                spawnRed()
            }
        case 9..<15:
            if(pinkCount <= pinkColor){
                pinkCount += 1
                spawnPink()
            }
        case 15..<18:
            if(greenCount <= greenColor){
                greenCount += 1
                spawnGreen()
            }
        case 18..<20:
            if(blueCount <= blueColor){
                blueCount += 1
                spawnBlue()
            }
        case 20:
            if(blackCount <= blackColor){
                blackCount += 1
                spawnBlack()
            }
        default:
            spawnRed()
        }
        
}
    
    
    //spawning bubblepop Explosion
    func spawnPopExplosion(spawnPosition: CGPoint){
        
        let popExplosion = SKSpriteNode(imageNamed: "pop")
        popExplosion.position = spawnPosition
        popExplosion.zPosition = 2
        popExplosion.setScale(0)
        self.addChild(popExplosion)
        
        let scaleIn = SKAction.scale(to: 0.5, duration: 0.1)
        let fadOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let popExplostionSequence = SKAction.sequence([bubblePopSound, scaleIn ,fadOut, delete])
        
        popExplosion.run(popExplostionSequence)
        
    }
    
    
    //bubbles functions
    func spawnRed(){
        
        if(nodeCount < maxBubbles){
            
            let redBubble = SKSpriteNode(imageNamed: "red")
            
            
            //specifying random X and/or Y position(s) using random()
            let randomXStart = random(min: gameArea.minX + redBubble.size.width , max: gameArea.maxX - redBubble.size.width)
            
            //specifying start and end point of bubble
            let startPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
            let endPoint = CGPoint(x:randomXStart , y: self.size.height)
            
            //crearing a bubble
            redBubble.name = "red"
            redBubble.setScale(2.8)
            redBubble.position = startPoint
            redBubble.zPosition = 1
            redBubble.physicsBody = SKPhysicsBody(rectangleOf: redBubble.size)
            redBubble.physicsBody!.affectedByGravity = false
            self.addChild(redBubble)
            nodeCount += 1
            
            //moving across screen
            let moveBubble = SKAction.move(to: endPoint , duration: 4)
            let deleteBubble = SKAction.removeFromParent()
            let bubbleSequence = SKAction.sequence([moveBubble, deleteBubble])
            redBubble.run(bubbleSequence)
            nodeCount -= 1
            redCount -= 1
        }
        
    }
    
    func spawnPink(){
        
        if(nodeCount < maxBubbles){

            let pinkBubble = SKSpriteNode(imageNamed: "pink")

            
            //specifying random X and/or Y position(s) using random()
            let randomXStart = random(min: gameArea.minX + pinkBubble.size.width , max: gameArea.maxX - pinkBubble.size.width)
            
            //specifying start and end point of bubble
            let startPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
            let endPoint = CGPoint(x:randomXStart , y: self.size.height)
            
            //crearing a bubble
            pinkBubble.name = "pink"
            pinkBubble.setScale(2.8)
            pinkBubble.position = startPoint
            pinkBubble.zPosition = 1
            pinkBubble.physicsBody = SKPhysicsBody(rectangleOf: pinkBubble.size)
            pinkBubble.physicsBody!.affectedByGravity = false
            self.addChild(pinkBubble)
            nodeCount += 1
            
            //moving across screen
            let moveBubble = SKAction.move(to: endPoint , duration: 4)
            let deleteBubble = SKAction.removeFromParent()
            let bubbleSequence = SKAction.sequence([moveBubble, deleteBubble])
            pinkBubble.run(bubbleSequence)
            nodeCount -= 1
            pinkCount -= 1
        }
        
    }
    
    func spawnGreen(){
        
        if(nodeCount < maxBubbles){
            
            let greenBubble = SKSpriteNode(imageNamed: "green")
            
            //specifying random X and/or Y position(s) using random()
            let randomXStart = random(min: gameArea.minX + greenBubble.size.width, max: gameArea.maxX - greenBubble.size.width)
            
            //specifying start and end point of bubble
            let startPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
            let endPoint = CGPoint(x:randomXStart , y: self.size.height)
            
            //crearing a bubble
            greenBubble.name = "green"
            greenBubble.setScale(2.8)
            greenBubble.position = startPoint
            greenBubble.zPosition = 1
            greenBubble.physicsBody = SKPhysicsBody(rectangleOf: greenBubble.size)
            greenBubble.physicsBody!.affectedByGravity = false
            self.addChild(greenBubble)
            nodeCount += 1
            
            //moving across screen
            let moveBubble = SKAction.move(to: endPoint , duration: 4)
            let deleteBubble = SKAction.removeFromParent()
            let bubbleSequence = SKAction.sequence([moveBubble, deleteBubble])
            greenBubble.run(bubbleSequence)
            nodeCount -= 1
            greenCount -= 1
        }
        
    }
    
    func spawnBlue(){
        
        if(nodeCount < maxBubbles){
            
            
            let blueBubble = SKSpriteNode(imageNamed: "blue")

            //specifying random X and/or Y position(s) using random()
            let randomXStart = random(min: gameArea.minX + blueBubble.size.width , max: gameArea.maxX - blueBubble.size.width)
            
            //specifying start and end point of bubble
            let startPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
            let endPoint = CGPoint(x:randomXStart , y: self.size.height)
            
            //crearing a bubble
            blueBubble.name = "blue"
            blueBubble.setScale(2.8)
            blueBubble.position = startPoint
            blueBubble.zPosition = 1
            blueBubble.physicsBody = SKPhysicsBody(rectangleOf: blueBubble.size)
            blueBubble.physicsBody!.affectedByGravity = false
            self.addChild(blueBubble)
            nodeCount += 1
            
            //moving across screen
            let moveBubble = SKAction.move(to: endPoint , duration: 3)
            let deleteBubble = SKAction.removeFromParent()
            let bubbleSequence = SKAction.sequence([moveBubble, deleteBubble])
            blueBubble.run(bubbleSequence)
            nodeCount -= 1
            blueCount -= 1
        }
        
    }
    
    func spawnBlack(){
        
        if(nodeCount < maxBubbles){
            
            let blackBubble = SKSpriteNode(imageNamed: "black")
            
            //specifying random X and/or Y position(s) using random()
            let randomXStart = random(min: gameArea.minX + blackBubble.size.width , max: gameArea.maxX - blackBubble.size.width)
            
            //specifying start and end point of bubble
            let startPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
            let endPoint = CGPoint(x:randomXStart , y: self.size.height)
            
            //crearing a bubble
            blackBubble.name = "black"
            blackBubble.setScale(2.8)
            blackBubble.position = startPoint
            blackBubble.zPosition = 1
            blackBubble.physicsBody = SKPhysicsBody(rectangleOf: blackBubble.size)
            blackBubble.physicsBody!.affectedByGravity = false
            self.addChild(blackBubble)
            nodeCount += 1
            
            //moving across screen
            let moveBubble = SKAction.move(to: endPoint , duration: 2)
            let deleteBubble = SKAction.removeFromParent()
            let bubbleSequence = SKAction.sequence([moveBubble, deleteBubble])
            blackBubble.run(bubbleSequence)
            nodeCount -= 1
            blackCount -= 1
        }
        
    }
    
    
    //touch function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(currentGameState == gameState.preGame){
            startGame()
        }
        
        let touch : UITouch = touches.first!
        let touchLocation = touch.location(in: self)
        
        for node in self.nodes(at: touchLocation)
        {
            if(currentGameState == gameState.inGame){
                if node.name == "red"
                {
                    spawnPopExplosion(spawnPosition: node.position)
                    node.removeFromParent()
                    redCount -= 1
                    nodeCount -= 1
                    addScore(color: "red")
                }
                if node.name == "pink"
                {
                    spawnPopExplosion(spawnPosition: node.position)
                    node.removeFromParent()
                    pinkCount -= 1
                    nodeCount -= 1
                    addScore(color: "pink")
                }
                if node.name == "green"
                {
                    spawnPopExplosion(spawnPosition: node.position)
                    node.removeFromParent()
                    greenCount -= 1
                    nodeCount -= 1
                    addScore(color: "green")
                }
                if node.name == "blue"
                {
                    spawnPopExplosion(spawnPosition: node.position)
                    node.removeFromParent()
                    blueCount -= 1
                    nodeCount -= 1
                    addScore(color: "blue")
                }
                if node.name == "black"
                {
                    spawnPopExplosion(spawnPosition: node.position)
                    node.removeFromParent()
                    redCount -= 1
                    nodeCount -= 1
                    addScore(color: "black")
                }
            }
        }
    }
    
}
