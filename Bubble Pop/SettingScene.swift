import Foundation
import SpriteKit
import UIKit
import QuartzCore


class SettingScene: SKScene, UITextFieldDelegate{
    
    let defaults = UserDefaults()
    
    let buttonSound = SKAction.playSoundFileNamed("buttonSound.wav", waitForCompletion: false)
    let min = SKSpriteNode(imageNamed: "min")
    let med = SKSpriteNode(imageNamed: "med")
    let max = SKSpriteNode(imageNamed: "max")
    let thirty = SKSpriteNode(imageNamed: "30Sec")
    let sixty = SKSpriteNode(imageNamed: "60Sec")
    let timeLable = SKLabelNode(fontNamed: "Balloony-Regular")
    let backLabel = SKLabelNode(fontNamed: "Balloony-Regular")
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "startBlur")
        background.size.height = self.size.height
        background.size.width = self.size.height * 8 / 5
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let speedLable = SKLabelNode(fontNamed: "Balloony-Regular")
        speedLable.text = "Bubbles On Screen"
        speedLable.fontSize = 90
        speedLable.fontColor = SKColor.white
        speedLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        speedLable.position = CGPoint(x: self.size.width*0.18, y: self.size.height*0.93)
        speedLable.zPosition = 2
        self.addChild(speedLable)
        
        
        timeLable.text = "Select Game Time"
        timeLable.fontSize = 90
        timeLable.fontColor = SKColor.white
        timeLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        timeLable.position = CGPoint(x: self.size.width*0.19, y: self.size.height*0.85 - min.size.height*3-6)
        timeLable.zPosition = 2
        self.addChild(timeLable)
        
        
        minNormal()
        medNormal()
        maxNormal()
        
        thirtyNormal()
        sixtyNormal()
        
        backLabel.name = "back"
        backLabel.text = "back"
        backLabel.fontSize = 100
        backLabel.fontColor = SKColor.white
        backLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.05)
        backLabel.zPosition = 1
        self.addChild(backLabel)
        
    }
    
    func minNormal(){
        
        if(defaults.string(forKey: "speed") == "min"){
            min.texture = SKTexture(imageNamed: "minSelect")
        }
        min.name = "min"
        min.setScale(1)
        min.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        min.zPosition = 2
        self.addChild(min)
    }
    
    func medNormal(){
        
        if(defaults.string(forKey: "speed") == "med"){
            med.texture = SKTexture(imageNamed: "medSelect")
        }
        med.name = "med"
        med.setScale(1)
        med.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85 - min.size.height+1)
        med.zPosition = 2
        self.addChild(med)
    }
    
    func maxNormal(){
        
        if(defaults.string(forKey: "speed") == "max"){
            max.texture = SKTexture(imageNamed: "maxSelect")
        }
        max.name = "max"
        max.setScale(1)
        max.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85 - min.size.height*2+1)
        max.zPosition = 2
        self.addChild(max)
    }
    
    func thirtyNormal(){
        
        if(defaults.string(forKey: "time") == "30"){
            thirty.texture = SKTexture(imageNamed: "30SecSelect")
        }
        thirty.name = "thirty"
        thirty.setScale(1)
        thirty.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.32)
        thirty.zPosition = 2
        self.addChild(thirty)
    }
    
    func sixtyNormal(){
        
        if(defaults.string(forKey: "time") == "60"){
            sixty.texture = SKTexture(imageNamed: "60SecSelect")
        }
        sixty.name = "sixty"
        sixty.setScale(1)
        sixty.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.32 - thirty.size.height+1)
        sixty.zPosition = 2
        self.addChild(sixty)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch : UITouch = touches.first!
        let touchLocation = touch.location(in: self)
        
        for node in self.nodes(at: touchLocation)
        {
            if node.name == "min"
            {
                self.run(buttonSound)
                defaults.set("min", forKey: "speed")
                min.texture = SKTexture(imageNamed: "minSelect")
                med.texture = SKTexture(imageNamed: "med")
                max.texture = SKTexture(imageNamed: "max")

                
            }
            
            if node.name == "med"
            {
                self.run(buttonSound)
                defaults.set("med", forKey: "speed")
                med.texture = SKTexture(imageNamed: "medSelect")
                min.texture = SKTexture(imageNamed: "min")
                max.texture = SKTexture(imageNamed: "max")
                
            }
            
            
            if node.name == "max"
            {
                self.run(buttonSound)
                defaults.set("max", forKey: "speed")
                max.texture = SKTexture(imageNamed: "maxSelect")
                med.texture = SKTexture(imageNamed: "med")
                min.texture = SKTexture(imageNamed: "min")
            }
            
            if node.name == "thirty"
            {
                self.run(buttonSound)
                defaults.set("30", forKey: "time")
                thirty.texture = SKTexture(imageNamed: "30SecSelect")
                sixty.texture = SKTexture(imageNamed: "60Sec")
            }
            
            if node.name == "sixty"
            {
                self.run(buttonSound)
                defaults.set("60", forKey: "time")
                sixty.texture = SKTexture(imageNamed: "60SecSelect")
                thirty.texture = SKTexture(imageNamed: "30Sec")
            }
            
            if node.name == "back"{
                
                self.run(changeSound)
                let sceneToMoveTo = MenuScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }

        }
    }


   
    
}
