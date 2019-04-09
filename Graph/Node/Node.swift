import Foundation
import SpriteKit
class Node: SKNode {
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
    override init() {
        super.init()
        
        //self.id = UUID().uuidString
    }
    
    convenience init(id:String,position:CGPoint,inp:Int,out:Int,tangibleDict:Any,view:SKView) {
        self.init()
        //print(tangibleDict)
        self.position = position
        if let funcname = (tangibleDict as? [String:Any]){
            //print(funcname)
            self.funcName = funcname["function"] as! String
            self.controledArgNames = funcname["controled_args"] as? [String] ?? []
            var multiplier:CGFloat = 3.0
            for item in self.controledArgNames{
                //print("I")
                //print("i am here bitches")
                //self.scene?.view.ad
                //view.translateOrigin(to: CGPoint(x:view.frame.width/2,y:view.frame.height/2))
                //self.scene?.view?.translateOrigin(to: )
                var textFieldFrame = CGRect(origin: CGPoint(x:self.position.x+20,y:self.position.y + 60.0 + multiplier*40.0), size: CGSize(width: 160, height: 60))
                var textField = NSTextField(frame: textFieldFrame)
                
                

                
                
                
                
                self.controledArgsTextField.append(textField)
                //textField.isEnabled = 
                textField.id = item
                //print(self.position)
                textField.setFrameOrigin(CGPoint(x:self.position.x+20,y:self.position.y + 60.0 + multiplier*60.0))
                multiplier-=1.0
                textField.backgroundColor = NSColor.white
                textField.placeholderString = "hello world"
                view.addSubview(textField)
                //view.addSubview(textField)
            }
            let label = SKLabelNode(text: id + " " + (funcname["function"] as! String))//SKLabelNode(text: funcname["function"] as? String)
            label.fontSize = 24
            self.addChild(label)
            label.position = CGPoint(x:0,y:180)
        }
        self.id = id
        self.maxInput = inp
        self.maxOutput = out
        
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
    
    
    
}


extension NSTextField{
    struct Holder {
        static var _id:String = ""
    }
    var id:String {
        get {
            return Holder._id
        }
        set(newValue) {
            Holder._id = newValue
        }
    }
}



