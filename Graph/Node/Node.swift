import Foundation
import SpriteKit
import MultiTouchKitSwift
import SwiftyJSON
class Node: SKNode,MTKButtonDelegate {
    var controlElements:ControlElements?
    
    var view:SKView?
    var button:MTKButton?
    var inputArcNames:[String] = []
    var controledArgNames:[String] = []
    var controledArgsTextField:[CustomTextFields] = []
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
    var json:JSON?
    var alias:String = ""
    var mainArgDicts:[String:JSON] = [:]
    var controledArgDicts:[String:String] = [:]
    var filePicker:MTKFileManager = MTKFileManager()
    var keyboard:Numpad = Numpad()
    
    override init() {
        super.init()
        
        //self.id = UUID().uuidString
    }
    
   
    
    @objc fileprivate func delete(button: MTKButton){
        NodeManager.removeNode(with: self.id!)
    }
    
    @objc func add(button:MTKButton){
        self.arcManager?.addOutputArc()
    }
    
    convenience init(id:String,position:CGPoint,json:JSON,view:SKView) {
        self.init()
        self.zPosition = 5
        self.view = view
        self.position = position
        self.id = id
        self.json = json
        if json["arguments"]["controled_args"].count != 0 {
            self.controlElements = ControlElements(json: json["arguments"]["controled_args"],node:self)
        }
        self.mainArgDicts = json["arguments"]["main_args"].dictionaryValue
        self.maxInput = Array(json["arguments"]["main_args"].dictionaryValue.keys).count
        self.funcName = json["function"].stringValue
        self.alias = json["alias"].stringValue
        self.drawTitleLabel(text: json["alias"].stringValue)
        var addButton = MTKButton(size: CGSize(width: 40, height: 40), image:"branch.png")
        var deleteButton = MTKButton(size: CGSize(width: 40, height: 40), image:"delete.png")
        deleteButton.position = CGPoint(x: 0, y: -70)
        addButton.position = CGPoint(x: 70, y: 0)
        self.addChild(deleteButton)
        self.addChild(addButton)
        addButton.add(target: self, action: #selector(self.add(button:)))
        deleteButton.add(target: self, action: #selector(self.delete(button:)))
        self.arcManager = ArcManager(node:self,json:json)
        if let args = json["arguments"].dictionary{
            self.arcManager?.inputArcNames = Array((args["main_args"]?.dictionaryValue.keys)!)
            self.inputArcNames = Array((args["main_args"]?.dictionaryValue.keys)!)
        }
        self.arcManager?.drawArcs()
        self.drawBase()
       
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBase(){
        let node = SKShapeNode(circleOfRadius: 100)
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
}





