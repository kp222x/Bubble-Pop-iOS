//
//  GameOverScene.swift
//  Bubble Pop
//
//  Created by Karan Parikh on 16/5/17.
//  Copyright © 2017 Karan Parikh. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{

    let restartLable = SKLabelNode(fontNamed: "Balloony-Regular")
    let menuLable = SKLabelNode(fontNamed: "Balloony-Regular")
    let defaults = UserDefaults()

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "start")
        background.size.height = self.size.height
        background.size.width = self.size.height * 8 / 5
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLable = SKLabelNode(fontNamed: "Balloony-Regular")
        gameOverLable.text = "GAME OVER"
        gameOverLable.fontSize = 170
        gameOverLable.fontColor = SKColor.white
        gameOverLable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.80)
        gameOverLable.zPosition = 1
        self.addChild(gameOverLable)
        
        restartLable.text = "RESTART"
        restartLable.fontSize = 100
        restartLable.fontColor = SKColor.white
        restartLable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.725)
        restartLable.zPosition = 1
        self.addChild(restartLable)
        
        let scoreLable = SKLabelNode(fontNamed: "Balloony-Regular")
        scoreLable.text = "SCORE: \(gameScore)"
        scoreLable.fontSize = 125
        scoreLable.fontColor = SKColor.white
        scoreLable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        scoreLable.zPosition = 1
        self.addChild(scoreLable)
        
        var userKey:String = ""
        
        var highScoreNumber = 0
        
        if(defaults.string(forKey: "currentUser") != nil) {
            let currentUser: String = defaults.string(forKey: "currentUser")!
            userKey = "user_\(currentUser)"
            highScoreNumber = defaults.integer(forKey: userKey)
        }
        else {
            defaults.set(0, forKey: userKey)
        }
        
        if(gameScore > highScoreNumber){
            highScoreNumber = gameScore
            //defaults.integer(forKey: "highScoreSaved")
            defaults.set(gameScore, forKey: userKey)
        }
        
        let highScoreLable = SKLabelNode(fontNamed: "Balloony-Regular")
        highScoreLable.text = "HIGH SCORE: \(highScoreNumber)"
        highScoreLable.fontSize = 125
        highScoreLable.fontColor = SKColor.white
        highScoreLable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.375)
        highScoreLable.zPosition = 1
        self.addChild(highScoreLable)
        
        
        menuLable.text = "Main Menu"
        menuLable.fontSize = 70
        menuLable.fontColor = SKColor.white
        menuLable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.25)
        menuLable.zPosition = 1
        self.addChild(menuLable)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches{
        
            let pointOfTouch = touch.location(in: self)
            
            if restartLable.contains(pointOfTouch){
                
                self.run(changeSound)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            
            }
            
            if menuLable.contains(pointOfTouch){
                
                self.run(changeSound)
                let sceneToMoveTo = MenuScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }

        }
    }

}
