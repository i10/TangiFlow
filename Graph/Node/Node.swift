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
        //print(tangibleDict)
        self.position = position
        if let funcname = (tangibleDict as? [String:Any]){
            //print(funcname)
            self.funcName = funcname["function"] as! String
            //print(funcname)
            //var arguments = funcname["arguments"] as! [String:[String:[String]]]
            //print(arguments)
            self.controledArgNames = (funcname["arguments"] as! [String:Any])["controled_args"] as? [String] ?? []
            if let buttonTitle = (funcname["arguments"] as! [String:Any])["button"] as? [String:String]{
                self.button = MTKButton(size: CGSize(width: 180, height: 50), label: buttonTitle["title"] ?? "" )
                self.button?.position = CGPoint(x: 0, y: -150)
                self.addChild(button!)
                self.button?.add(target: self, action: #selector(self.buttonPressed(button:)))
            }
            
            var multiplier:CGFloat = 3.0
            for item in self.controledArgNames{

                var textFieldFrame = CGRect(origin: CGPoint(x:self.position.x+20,y:self.position.y + 60.0 + multiplier*40.0), size: CGSize(width: 160, height: 60))
                var textField = NSTextField(frame: textFieldFrame)
                self.controledArgsTextField.append(textField)
                //textField.isEnabled = 
                //textField.id = item
                //print(self.position)
                textField.setFrameOrigin(CGPoint(x:self.position.x+20,y:self.position.y + 60.0 + multiplier*60.0))
                multiplier-=1.0
                textField.backgroundColor = NSColor.white
                textField.placeholderString = item
                view.addSubview(textField)
                //view.addSubview(textField)
            }
            self.label = SKLabelNode(text: id + " " + (funcname["function"] as! String))//SKLabelNode(text: funcname["function"] as? String)
            self.label!.fontSize = 24
            self.addChild(self.label!)
            self.label!.position = CGPoint(x:0,y:180)
            self.id = id
            self.maxInput = ((funcname["arguments"] as! [String:Any])["main_args"] as? [String])?.count ?? 0
            self.maxOutput = out
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
    
    
    
}





