import Foundation
import SpriteKit
class Slider: SKNode {
    var alias:String = ""
    var min:CGFloat = 0
    var max:CGFloat = 1
    var step:CGFloat = 0.1
    var bar:SKShapeNode = SKShapeNode(rectOf: CGSize(width: 200, height: 20))
    var button:SKShapeNode = SKShapeNode(rectOf: CGSize(width: 40, height: 40))
    var currentValueLabel:SKLabelNode?
    var currentValue:String = ""
    var values:[CGFloat] = []
    var pixelValues:[CGFloat] = []
    var isInt:Bool {
        get {
            return step == 1.0
        }
    }
    var totalSteps:Int{
        get{
            return Int(abs(max-min)/step)
        }
    }
    var pixelsPerStep:CGFloat{
        get{
            return 160.0/self.distance
        }
    }
    
    var distance:CGFloat{
        get{
            return abs(max-min)
        }
    }
    
    override init() {
        super.init()
        self.drawBar()
        self.drawSliderButton()
        self.drawSideLabels()
        for index in 0..<self.totalSteps{
            self.values.append(CGFloat(index)*step+min)
            self.pixelValues.append(CGFloat(index)*pixelsPerStep-80)
        }
        print(self.values)
        print(self.pixelValues)
        self.currentValue = "\(self.min)"
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawBar(){
        self.bar.fillColor = SKColor.gray
        self.addChild(self.bar)
    }
    
    func drawSliderButton(){
        self.currentValueLabel = SKLabelNode(text: String(self.currentValue))
        self.currentValueLabel!.position = CGPoint(x: 0, y: 30)
        self.button.position = CGPoint(x: -80, y: 0)
        self.button.addChild(self.currentValueLabel!)
        self.button.fillColor = SKColor.black
        self.bar.addChild(self.button)
        self.button.name = "sliderButton"
    }
    
    func drawSideLabels(){
        let leftLabel:SKLabelNode = SKLabelNode(text: "\(self.min)")
        let rightLabel:SKLabelNode = SKLabelNode(text: "\(self.max)")
        leftLabel.position = CGPoint(x: -100 - leftLabel.frame.width, y: -13)
        rightLabel.position = CGPoint(x:100 + rightLabel.frame.width/1.5,y:-13)
        self.addChild(leftLabel)
        self.addChild(rightLabel)
    }
    
    func countValue(){
        let value = abs(-80.0-button.position.x)/self.pixelsPerStep
        //self.currentValueLabel!.text = "\(value)"
        if self.isInt{
            self.currentValueLabel!.text = String( Int(round(value)))
            self.currentValue = String( Int(round(value)))
            
        } else{
            self.currentValueLabel!.text = String(format: "%.1f", value)
            self.currentValue = String(format: "%.1f", value)
        }
        
    }
}

