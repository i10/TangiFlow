import Foundation
import SpriteKit
class Slider: SKNode {
    var image:ImageTypeResultNode?
    var alias:String = ""
    var min:CGFloat = 0
    var max:CGFloat = 1
    var step:CGFloat = 0.1
    var bar:SKShapeNode = SKShapeNode(rectOf: CGSize(width: 120, height: 1))
    var button:SKShapeNode = SKShapeNode.init(circleOfRadius: 6)
    var currentValueLabel:SKLabelNode?
    var currentValue:String = ""
    var values:[CGFloat] = []
    var pixelValues:[CGFloat] = []
    var defaultVal:CGFloat = 0
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
            return 120.0/self.distance
        }
    }
    
    var distance:CGFloat{
        get{
            return abs(max-min)
        }
    }
    
    override init() {
        super.init()
        
        
    }
    
    convenience init(min:CGFloat = 0,max:CGFloat = 10.0 , step:CGFloat = 1.0 , defaultVal:CGFloat = 0) {
        self.init()
        self.min = min
        self.max = max
        self.step = step
        self.defaultVal = defaultVal
        self.drawBar()
        self.drawSliderButton()
        self.drawSideLabels()
        for index in 0..<self.totalSteps{
            self.values.append(CGFloat(index)*step+min)
            self.pixelValues.append(CGFloat(index)*pixelsPerStep-60)
        }
        self.currentValue = "\(self.defaultVal)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawBar(){
        self.bar.fillColor = SKColor.gray
        self.bar.position.y = -120.0
        self.addChild(self.bar)
    }
    
    func drawSliderButton(){
        self.currentValueLabel = SKLabelNode(text: "\(self.defaultVal)")
        self.currentValueLabel?.fontSize = 20.0
        self.currentValueLabel!.position = CGPoint(x: 0, y: 30)
        self.button.position = CGPoint(x: self.countPosition(), y: 0)
        self.button.addChild(self.currentValueLabel!)
        self.button.fillColor = SKColor.black
        self.bar.addChild(self.button)
        self.button.name = "sliderButton"
    }
    
    func drawSideLabels(){
        let leftLabel:SKLabelNode = SKLabelNode(text: "\(self.min)")
        let rightLabel:SKLabelNode = SKLabelNode(text: "\(self.max)")
        leftLabel.position = CGPoint(x: -50 - leftLabel.frame.width, y: -108)
        rightLabel.position = CGPoint(x:50 + rightLabel.frame.width/1.5,y:-108)
        leftLabel.fontSize = 20.0
        rightLabel.fontSize = 20.0
        self.addChild(leftLabel)
        self.addChild(rightLabel)
    }
    
    func countValue(){
        if let parent = self.parent as? Node {
            if parent.funcName  != "image_source"{
                parent.changeBaseColor(color: NSColor(calibratedRed: 255.0/255.0, green: 230.0/255.0, blue: 77.0/255.0, alpha: 1.0))
                
            }
        }
        
        let distance = abs(-60.0-button.position.x)/self.pixelsPerStep
        //self.currentValueLabel!.text = "\(value)"
        if self.isInt{
            self.currentValueLabel!.text = String( Int(round(min + distance)))
            self.currentValue = String( Int(round(min + distance)))
            
        } else{
            self.currentValueLabel!.text = String(format: "%.1f", min+distance)
            self.currentValue = String(format: "%.1f", min+distance)
        }
        
        if let image = self.image{
            (self.parent?.parent as! Node).zoomValue = CGFloat((currentValue as NSString).doubleValue )
            image.reloadImage(zoom: CGFloat((currentValue as NSString).doubleValue ))
        }
    }
    
    func countPosition() -> CGFloat{
        let distance = abs(self.min - self.defaultVal)*self.pixelsPerStep
        let position = -60 + distance
        return position
    }
    
    func drawLabel(){
        let label = SKLabelNode(text: self.alias)
        label.position = CGPoint(x: -60, y: -60)
        self.addChild(label)
    }
}

