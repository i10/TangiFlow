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
//    var label:SKLabelNode?
    var sourceData:SKNode?
    override init() {
        super.init()
        
        //self.id = UUID().uuidString
    }
    
    @objc fileprivate func buttonPressed(button: MTKButton) {
        let dialogue = NSOpenPanel()
        dialogue.canChooseFiles = true
        dialogue.showsResizeIndicator = true
        dialogue.allowedFileTypes = ["jpg","png","bmp","tiff","jpeg","tff","gif"]
        if (dialogue.runModal() == NSApplication.ModalResponse.OK){
            if let url = dialogue.url{
                print("dd")
                print(url.absoluteString)
                
                self.sourceData?.removeFromParent()
                self.sourceData = ImageTypeResultNode(url:url)
                (self.sourceData as! ImageTypeResultNode).url = url.absoluteString
                self.sourceData?.position = CGPoint(x: -300, y: 0)
                self.addChild(self.sourceData!)
            }else{
                
            }
        }
    }
    
    convenience init(id:String,position:CGPoint,out:Int,tangibleDict:Any,view:SKView) {
        
        self.init()
        
        self.position = position
        self.id = id
        self.maxOutput = out
        if let funcname = (tangibleDict as? [String:Any]){
            self.maxInput = ((funcname["arguments"] as! [String:Any])["main_args"] as? [String])?.count ?? 0
            if let buttonTitle = (funcname["arguments"] as! [String:Any])["button"] as? [String:String]{
                self.button = MTKButton(size: CGSize(width: 180, height: 50), label: buttonTitle["title"] ?? "" )
                self.button?.position = CGPoint(x: 0, y: -150)
                self.addChild(button!)
                self.button?.add(target: self, action: #selector(self.buttonPressed(button:)))
            }
            
            self.funcName = funcname["function"] as! String
            self.controledArgNames = (funcname["arguments"] as! [String:Any])["controled_args"]! as? [String] ?? []
            self.drawTextFields(view: view)
            self.drawTitleLabel(text: funcname["function"] as! String)
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
        let label = SKLabelNode(text: self.id! + " " + text)//SKLabelNode(text: funcname["function"] as? String)
        label.fontSize = 18
        self.addChild(label)
        label.position = CGPoint(x:0,y:120)
    }
    
    func drawTextFields(view:SKView){
        
        var multiplier:CGFloat = 3.0
        for item in self.controledArgNames{
            let textFieldFrame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 160, height: 60))
            let textField = NSTextField(frame: textFieldFrame)
            textField.backgroundColor = NSColor.red
            self.controledArgsTextField.append(textField)
            textField.setFrameOrigin(CGPoint(x:self.position.x+20,y:self.position.y + 60 + multiplier*60.0))
            multiplier-=1.0
            textField.backgroundColor = NSColor.white
            textField.placeholderString = item
            view.addSubview(textField)
        }
    }
    
    
}





