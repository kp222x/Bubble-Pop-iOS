import Foundation
import SpriteKit
import UIKit


let changeSound = SKAction.playSoundFileNamed("wave.wav", waitForCompletion: false)

class MenuScene: SKScene, UITextFieldDelegate{
    
    let defaults = UserDefaults()
    
    let myColor : UIColor = UIColor( red: 0, green: 0, blue: 0, alpha: 1.0)
    let startLabel = SKLabelNode(fontNamed: "Balloony-Regular")
    let loginLabel = SKLabelNode(fontNamed: "Balloony-Regular")
    let settings = SKSpriteNode(imageNamed: "setting")
    let newUser = SKSpriteNode(imageNamed: "newUser")
    let scoreBoard = SKSpriteNode(imageNamed: "scoreBoard")

    override func didMove(to view: SKView) {
        
        //default values for settings
        if(defaults.string(forKey: "speed") == nil){
            defaults.set("med", forKey: "speed")
        }
        
        if(defaults.string(forKey: "time") == nil){
            defaults.set("60", forKey: "time")
        }
        //adding background
        let background = SKSpriteNode(imageNamed: "start")
        background.size.height = self.size.height
        background.size.width = self.size.height * 8 / 5
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        //adding labels
        var currentUser: String = ""
        if(defaults.string(forKey: "currentUser") != nil){
            currentUser = defaults.string(forKey: "currentUser")!
            loginLabel.alpha = 1
        }else{
            loginLabel.alpha = 0
        }
        loginLabel.text = "\(currentUser)"
        loginLabel.fontSize = 70
        loginLabel.fontColor = SKColor.white
        loginLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        loginLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.95)
        loginLabel.zPosition = 2
        self.addChild(loginLabel)
        
        scoreBoard.name = "scoreBoard"
        scoreBoard.setScale(0.9)
        scoreBoard.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.96)
        scoreBoard.zPosition = 2
        self.addChild(scoreBoard)
        
        newUser.name = "newUser"
        newUser.setScale(0.8)
        loginLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        newUser.position = CGPoint(x: self.size.width*0.82, y: self.size.height*0.96)
        newUser.zPosition = 2
        self.addChild(newUser)
        
        let title1Lable = SKLabelNode(fontNamed: "Balloony-Regular")
        title1Lable.text = "BUBBLE"
        title1Lable.fontSize = 200
        title1Lable.fontColor = SKColor.white
        title1Lable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        title1Lable.zPosition = 2
        self.addChild(title1Lable)
        
        let title2Lable = SKLabelNode(fontNamed: "Balloony-Regular")
        title2Lable.text = "POP"
        title2Lable.fontSize = 200
        title2Lable.fontColor = SKColor.white
        title2Lable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        title2Lable.zPosition = 2
        self.addChild(title2Lable)
        
        startLabel.text = "START"
        startLabel.fontSize = 150
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        startLabel.zPosition = 2
        self.addChild(startLabel)
        
        settings.name = "setting"
        settings.setScale(1)
        settings.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.15)
        settings.zPosition = 2
        self.addChild(settings)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if startLabel.contains(pointOfTouch){
                
                if(defaults.string(forKey: "currentUser") != nil) {
                    let sceneToMoveTo = GameScene(size: self.size)
                    sceneToMoveTo.scaleMode =  self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }else{
                    let sceneToMoveTo = NewUserScene(size: self.size)
                    sceneToMoveTo.scaleMode =  self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
            }
            
            if settings.contains(pointOfTouch){
                
                self.run(changeSound)
                let sceneToMoveTo = SettingScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if newUser.contains(pointOfTouch){
                
                self.run(changeSound)
                let sceneToMoveTo = NewUserScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if scoreBoard.contains(pointOfTouch){
                
                self.run(changeSound)
                let sceneToMoveTo = ScoreboardScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
    }
    
}


