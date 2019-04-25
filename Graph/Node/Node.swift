import Foundation
import SpriteKit
import MultiTouchKitSwift
class Node: SKNode,MTKButtonDelegate {
    var button:MTKButton?
    var inputArcNames:[String] = []
    var controledArgNames:[String] = []
    var controledArgsTextField:[NSTextField] = []
    var id:String?
    var maxInput:Int = 1
    var maxOutput:Int = 1
    var arcManager:ArcManager?
    var terminal = false
    var inArgs:[String:String] = [:]
    var outArgs:[String:String] = [:]
    var funcName:String = ""
    var label:SKLabelNode?
    var sourceData:SKNode?
    var sourceUrl:String = ""
    var tangibleDict:[String:Any] = [:]
    var alias:String = ""
    override init() {
        super.init()
        
        //self.id = UUID().uuidString
    }
    
    @objc fileprivate func buttonPressed(button: MTKButton) {
        var filePicker = MTKFileManager()
        filePicker.node = self
        filePicker.position = CGPoint(x: 600, y: 600)
        self.scene?.addChild(filePicker)
    }
    
    
    @objc func addButtonPressed(button:MTKButton){
        self.arcManager?.addOutputArc()
    }
    
    convenience init(id:String,position:CGPoint,out:Int,tangibleDict:Any,view:SKView) {
        
        self.init()
        
        self.position = position
        
        
       
        
        self.id = id
        self.maxOutput = out
        if let funcname = (tangibleDict as? [String:Any]){
            self.tangibleDict = funcname
            self.maxInput = ((funcname["arguments"] as! [String:Any])["main_args"] as? [String])?.count ?? 0
            if let buttonTitle = (funcname["arguments"] as! [String:Any])["button"] as? [String:String]{
                print("I AM THE TITLE")
                print(buttonTitle)
                
                self.button = MTKButton(size: CGSize(width: 50, height: 50), image:"/Users/ppi/Desktop/open.png" )
                self.button?.name = buttonTitle["arg"]!
                self.button?.position = CGPoint(x: -50, y: -150)
                self.addChild(button!)
                self.button?.add(target: self, action: #selector(self.buttonPressed(button:)))
            }
            
            self.funcName = funcname["function"] as! String
            if !self.funcName.contains("terminal"){
                var addButton = MTKButton(size: CGSize(width: 50, height: 50), image:"/Users/ppi/Desktop/plus.png")
                if self.button != nil {
                    addButton.position = CGPoint(x: 50, y: -150)}
                else {
                    addButton.position = CGPoint(x: 0, y: -150)
                }
                self.addChild(addButton)
                addButton.add(target: self, action: #selector(self.addButtonPressed(button:)))
            }
            self.controledArgNames = (funcname["arguments"] as! [String:Any])["controled_args"]! as? [String] ?? []
            self.drawTextFields(view: view)
            self.alias = funcname["alias"] as! String
            self.drawTitleLabel(text: funcname["alias"] as! String)
        }
        self.arcManager = ArcManager(node:self,tangibleDict:tangibleDict)
        if let args = ((tangibleDict as! [String:Any])["arguments"]) as? [String:[String]]{
            self.arcManager?.inputArcNames = args["main_args"] ?? []
            self.inputArcNames = args["main_args"] ?? []
        }
        self.arcManager?.drawArcs()
        self.drawBase()
       
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBase(){
        let node = SKShapeNode(circleOfRadius: 80)
        node.position = CGPoint(x: 0, y: 0)
        node.fillColor = NSColor.white
        self.addChild(node)
    }
    
    func drawTitleLabel(text:String){
        self.label = SKLabelNode(text:text)//SKLabelNode(text: funcname["function"] as? String)
        label?.fontSize = 30
        self.addChild(label!)
        label?.position = CGPoint(x:0,y:160)
    }
    
    func drawTextFields(view:SKView){
        
        var multiplier:CGFloat = 3.0
        for item in self.controledArgNames{
            let textFieldFrame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 160, height: 60))
            let textField = NSTextField(frame: textFieldFrame)
            textField.backgroundColor = NSColor.red
            self.controledArgsTextField.append(textField)
            textField.setFrameOrigin(CGPoint(x:self.position.x-80,y:self.position.y + 60 + multiplier*60.0))
            multiplier-=1.0
            textField.backgroundColor = NSColor.white
            textField.placeholderString = item
            view.addSubview(textField)
        }
    }
    
    
}





