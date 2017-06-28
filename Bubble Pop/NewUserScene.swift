import Foundation
import SpriteKit
import UIKit


class NewUserScene: SKScene, UITextFieldDelegate{
    
    var username = UITextField()
    let defaults = UserDefaults()
    let beginLable = SKLabelNode(fontNamed: "Balloony-Regular")

    override func didMove(to view: SKView) {
        
        //adding background
        let background = SKSpriteNode(imageNamed: "blurBack")
        background.size.height = self.size.height
        background.size.width = self.size.height * 8 / 5
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let tfx: CGFloat = (view.bounds.width - view.bounds.width*0.7) / 2
        username.frame = CGRect(x: tfx,y: view.bounds.height * 0.3, width: view.bounds.width*0.7, height: 40)
        
        // add the UITextField to the GameScene's view
        view.addSubview(username)
        
        // add the gamescene as the UITextField delegate.
        // delegate funtion called is textFieldShouldReturn:
        username.delegate = self as UITextFieldDelegate
        username.borderStyle = UITextBorderStyle.roundedRect
        username.textColor = SKColor.black
        username.placeholder = "Enter your name"
        username.backgroundColor = SKColor.white
        username.autocorrectionType = UITextAutocorrectionType.yes
        
        username.clearButtonMode = UITextFieldViewMode.whileEditing
        username.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        self.view!.addSubview(username)
        
        
        beginLable.text = "Let's Play"
        beginLable.fontSize = 120
        beginLable.fontColor = SKColor.white
        beginLable.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        beginLable.zPosition = 2
        self.addChild(beginLable)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{

            let pointOfTouch = touch.location(in: self)

            if beginLable.contains(pointOfTouch){
                
                if(username.text != "") {
                    defaults.set(username.text, forKey: "currentUser")
                    username.removeFromSuperview()
                    let sceneToMoveTo = GameScene(size: self.size)
                    sceneToMoveTo.scaleMode =  self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
            }
            //dismiss keyboard
            view?.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Populates the SKLabelNode
        username.text = textField.text
        
        // Hides the keyboard
        
        textField.resignFirstResponder()
        return true
    }
}
