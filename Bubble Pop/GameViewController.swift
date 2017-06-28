//
//  GameViewController.swift
//  Bubble Pop
//
//  Created by Karan Parikh on 12/5/17.
//  Copyright © 2017 Karan Parikh. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    var backingAudio = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = Bundle.main.path(forResource: "backingAudio" , ofType: "mp3")
        let audioURL = NSURL(fileURLWithPath: file!)
        
        do { backingAudio = try AVAudioPlayer(contentsOf: audioURL as URL) }
        catch { return print("Can not find the audio")}
        
        backingAudio.numberOfLoops = -1
        backingAudio.play()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: CGSize(width: 1536, height:2048))
            // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
