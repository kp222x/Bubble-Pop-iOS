import Foundation
import SpriteKit
import UIKit

class ScoreboardScene: SKScene, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let defaults = UserDefaults()

    let backLabel = SKLabelNode(fontNamed: "Balloony-Regular")
    
    var names:[String] = []
    var scores:[Int] = []
    var uCount:Int = 0
    let scoreCardView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "start")
        background.size.height = self.size.height
        background.size.width = self.size.height * 8 / 5
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        uCount = 0
        for element in UserDefaults.standard.dictionaryRepresentation() {
            
            if(element.key.contains("user_")) {
                var str:String = element.key
                let index = str.index(str.startIndex, offsetBy: 5)
                str = str.substring(from: index)  // playground
                names.append(str)
                scores.append(element.value as! Int)
                uCount = uCount + 1
                print("\(element.key) - score is \(element.value)")
            }

        }
        self.view?.addSubview(scoreCardView)
        scoreCardView.register(ScoreCell.self, forCellWithReuseIdentifier: "cellId")
        scoreCardView.delegate = self
        scoreCardView.dataSource = self
        
        scoreCardView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        scoreCardView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        scoreCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        scoreCardView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6).isActive = true
        
        backLabel.text = "back"
        backLabel.fontSize = 90
        backLabel.fontColor = SKColor.white
        backLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        backLabel.zPosition = 1
        self.addChild(backLabel)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ScoreCell
        cell.nameView.text = names[indexPath.item]
        cell.hsView.text = "\(scores[indexPath.item])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: scoreCardView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return uCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom:10, right: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if backLabel.contains(pointOfTouch){
                scoreCardView.removeFromSuperview()
                self.run(changeSound)
                let sceneToMoveTo = MenuScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
    }
    

    
}

class ScoreCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let nameView:UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.font = UIFont(name: "Balloony-Regular", size: 24)
        view.textColor = .white
        view.text = "Name of Player"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let hsView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.textAlignment = .right
        view.font = UIFont(name: "Balloony-Regular", size: 24)
        view.textColor = .white
        view.text = "999"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(nameView)
        addSubview(hsView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[v0]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[v0]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": hsView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[v1]-1-[v0(100)]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": hsView, "v1": nameView]))
    }
}


