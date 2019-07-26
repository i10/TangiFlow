import Foundation
import SpriteKit
import MultiTouchKitSwift
import SwiftyJSON
class Node: SKNode,MTKButtonDelegate {
    var preview:Bool = true
    var hideButton = MTKButton(size: CGSize(width: 190, height: 40), label: "Hide output")
    var result:SKNode? = nil {
        didSet{
            hideButton.removeFromParent()
            self.addChild(hideButton)
            hideButton.position = CGPoint(x: 0, y: -190)
            hideButton.add(target: self, action: #selector(self.tapHide(button:)))
        }
    }
    var controlElements:ControlElements?
    var zoomSlider:Slider?
    var zoomValue:CGFloat = 1.0
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
    var keyboard:Keyboard = Keyboard()
    var playButton:MTKButton = MTKButton(size: CGSize(width: 30, height: 30),image:"fplay.png")
    var base:SKShapeNode = SKShapeNode(circleOfRadius: 100)
    var status = SKLabelNode(text: "RUNNING")
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
        status.fontColor = .black
        status.fontSize = 20
        self.zPosition = 5
        self.view = view
        self.position = position
        self.id = id
        self.json = json
        self.addChild(playButton)
        if json["arguments"]["controled_args"].count != 0 {
            self.controlElements = ControlElements(json: json["arguments"]["controled_args"],node:self)
        }
        self.mainArgDicts = json["arguments"]["main_args"].dictionaryValue
        self.maxInput = Array(json["arguments"]["main_args"].dictionaryValue.keys).count
        self.funcName = json["function"].stringValue
        self.alias = json["alias"].stringValue
        self.drawTitleLabel(text: json["alias"].stringValue)
        var addButton = MTKButton(size: CGSize(width: 30, height: 30), image:"fbranch.png")
        var deleteButton = MTKButton(size: CGSize(width: 30, height: 30), image:"ftrash.png")
        //var playButton = MTKButton(size: CGSize(width: 40, height: 40),image:"play.png")
        playButton.add(target: self, action: #selector(self.play(button:)))
        
        playButton.position = CGPoint(x: 0, y: 70)
        deleteButton.position = CGPoint(x: -70, y: 0)
        addButton.position = CGPoint(x: 70, y: 0)
        self.addChild(deleteButton)
        self.addChild(addButton)
        
        addButton.add(target: self, action: #selector(self.add(button:)))
        deleteButton.add(target: self, action: #selector(self.delete(button:)))
        self.arcManager = ArcManager(node:self,json:json)
        if let args = json["arguments"].dictionary{
            self.arcManager?.inputArcNames = Array(((args["main_args"]?.dictionaryValue.keys)!))
            self.inputArcNames = Array((args["main_args"]?.dictionaryValue.keys)!)
        }
        self.arcManager?.drawArcs()
        self.drawBase()
       
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBase(){
        
        self.base.fillColor = NSColor.white
        self.addChild(self.base)
    }
    
    func drawTitleLabel(text:String){
        self.label = SKLabelNode(text:text)//SKLabelNode(text: funcname["function"] as? String)
        label?.fontSize = 30
        self.addChild(label!)
        label?.position = CGPoint(x:0,y:185)
    }
    
    @objc func play(button:MTKButton){
        //self.crawl()
        if status.parent == nil {
            self.addChild(status)
            
        }
        button.set(size: CGSize(width: 20, height: 20), image:"fplay.png")
        let scr = ScriptRunner()
        scr.script(id:button.name!)
        let resultMaker = ResultVisualization()
        resultMaker.getResults()
        print(self.inArgs)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            button.set(size: CGSize(width: 30, height: 30), image:"fplay.png")
        }
        
    }
    
    func changeBaseColor(color:NSColor){
        self.base.fillColor = color
    }
    
    func crawl(){
        var checked:[Node] = [self]
        var checking:[Node] = [self]
        var result:[Node] = []
//        for (_,value) in self.inArgs{
//            if let node = NodeManager.getNode(with: value){
//                checking.append(node)
//                result.append(node)
//                checked.append(node)
//            }
//
//        }
        while !checking.isEmpty{
            var popped = checking.popLast()
            for (_,value) in popped!.inArgs{
                if let node = NodeManager.getNode(with: value){
                    checking.append(node)
                }
            }
            result.append(popped!)
            checked.append(popped!)
            checking = checking.filter{$0.id != popped?.id}
        }
        print("=============")
        for item in result{
            item.changeBaseColor(color: NSColor(calibratedRed: 144/255.0, green: 238.0/255.0, blue: 144/255.0, alpha: 1.0))
        }
        print("=============")
    }
    
    
    @objc func tapHide(button:MTKButton){
        if button.titleLabel?.text == "Hide output"{
            self.result?.isHidden = true
            self.preview = false
            button.titleLabel?.text = "Show output"
        }else{
            self.result?.isHidden = false
            self.preview = true
             button.titleLabel?.text = "Hide output"
        }
    }
}
