import Foundation
import SpriteKit
import MultiTouchKitSwift
import SwiftyJSON
class Node: SKNode,MTKButtonDelegate {
    var controlElements:ControlElements?
//    var zoomSlider:Slider?
//    var zoomValue:CGFloat = 1.0
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
    
    // Control Buttons
    var playButton: MTKButton = MTKButton(size: CGSize(width: 20, height: 20),image: "playGlyph")
    let listButton = MTKButton(size: CGSize(width: 20.0, height: 20.0), image: "listGlyph")
    let assignButton = MTKButton(size: CGSize(width: 20.0, height: 20.0), image: "assignGlyph")
    let touchButton = MTKButton(size: CGSize(width: 20.0, height: 20.0), image: "touchGlyph")
    let starButton = MTKButton(size: CGSize(width: 20.0, height: 20.0), image: "starGlyph")
    let addButton = MTKButton(size: CGSize(width: 20, height: 20), image:"branchGlyph")
    let deleteButton = MTKButton(size: CGSize(width: 20, height: 20), image:"trashGlyph")
    
    var base:SKShapeNode = SKShapeNode(circleOfRadius: 50)
    var status = SKLabelNode(text: "RUNNING")
    var assignedTo: Node?
    
    override init() {
        super.init()
        
        //self.id = UUID().uuidString
    }
    
   
    
    @objc fileprivate func delete(button: MTKButton){
        NodeManager.removeNode(with: self.id!)
    }
    
    @objc func add(button:MTKButton){
//        self.arcManager?.addOutputArc()
        let miniMap = MiniMap(node: self)
        self.addChild(miniMap)
    }
    
    convenience init(id:String,position:CGPoint,json:JSON) {
        self.init()
        
        status.fontColor = .black
        status.fontSize = 20
        status.name = "Status"
        self.zPosition = 5
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
        
        if !id.contains(".40") {
            self.drawTitleLabel(text: "\(self.id!.split(separator: ".").last ?? "")")
        }
        
        if id.contains(".40") {
            guard let slider = self.children.filter({ $0 is Slider }).first else { return }
            
            slider.isHidden = true
        }
        
        self.position = CGPoint(x: CGFloat(json["x"].floatValue), y: CGFloat(json["y"].floatValue))
        playButton.add(target: self, action: #selector(self.play(button:)))
        
        if !id.contains(".40") {
            if json["alias"].stringValue.contains("contrast") {
                let texture = SKTexture.init(image: #imageLiteral(resourceName: "contrast"))
                let spriteNode = SKSpriteNode(texture: texture)
                spriteNode.position = .zero
                spriteNode.size = CGSize(width: 30.0, height: 30.0)
                self.base.addChild(spriteNode)
            } else if json["alias"].stringValue.contains("brightness") {
                let texture = SKTexture.init(image: #imageLiteral(resourceName: "brightness"))
                let spriteNode = SKSpriteNode(texture: texture)
                spriteNode.position = .zero
                spriteNode.size = CGSize(width: 30.0, height: 30.0)
                self.base.addChild(spriteNode)
            } else if json["alias"].stringValue.contains("sharpness") {
                let texture = SKTexture.init(image: #imageLiteral(resourceName: "sharpness"))
                let spriteNode = SKSpriteNode(texture: texture)
                spriteNode.position = .zero
                spriteNode.size = CGSize(width: 30.0, height: 30.0)
                self.base.addChild(spriteNode)
            } else if json["alias"].stringValue.contains("saturation") {
                let texture = SKTexture.init(image: #imageLiteral(resourceName: "saturation"))
                let spriteNode = SKSpriteNode(texture: texture)
                spriteNode.position = .zero
                spriteNode.size = CGSize(width: 30.0, height: 30.0)
                self.base.addChild(spriteNode)
            }
        }
        
        playButton.position = CGPoint(x: 0, y: 100)
        deleteButton.position = CGPoint(x: -79, y: 65)
        addButton.position = CGPoint(x: 100, y: 0)
        self.addChild(deleteButton)
        self.addChild(addButton)
        
        addButton.add(target: self, action: #selector(self.add(button:)))
        deleteButton.add(target: self, action: #selector(self.delete(button:)))
        self.arcManager = ArcManager(node:self,json:json)
        if let args = json["arguments"].dictionary{
            self.arcManager?.inputArcNames = Array((args["main_args"]?.dictionaryValue.keys)!)
            self.inputArcNames = Array((args["main_args"]?.dictionaryValue.keys)!)
        }
        
        assignButton.position = CGPoint(x: -79.0, y: -65.0)
        assignButton.add(target: self, action: #selector(self.assignButtonTapped(_:)))
        self.addChild(assignButton)
        
        touchButton.position = CGPoint(x: 79.0, y: -65.0)
        touchButton.add(target: self, action: #selector(self.touchButtonTapped(_:)))
        self.addChild(touchButton)
        
//        let disconnectButton = MTKButton(size: CGSize(width: 20.0, height: 20.0), image: "disconnectGlyph")
//        disconnectButton.position = CGPoint(x: -79.0, y: -65.0)
//        disconnectButton.add(target: self, action: #selector(self.disconnectButtonTapped(_:)))
//        self.addChild(disconnectButton)

        listButton.position = CGPoint(x: -110.0, y: 0.0)
        listButton.add(target: self, action: #selector(self.listButtonTapped(_:)))
        self.addChild(listButton)
        
        starButton.position = CGPoint(x: 79, y: 65)
        starButton.add(target: self, action: #selector(self.starButtonTapped(_:)))
        self.addChild(starButton)
        
        self.arcManager?.drawArcs()
        self.drawBase()
    }
    
    @objc fileprivate func starButtonTapped(_ sender: MTKButton) {
        let starView = StarView(with: self, and: self.scene!)
        self.addChild(starView)
    }
    
    @objc fileprivate func touchButtonTapped(_ sender: MTKButton) {
        
    }
    
    @objc fileprivate func listButtonTapped(_ sender: MTKButton) {
        guard let node = sender.parent as? Node else { return }
        
        let listView = ListView(node: node)
        self.addChild(listView)
    }
    
    @objc fileprivate func assignButtonTapped(_ sender: MTKButton) {
        if self.assignedTo != nil { // already assigned
            self.assignedTo!.childNode(withName: "Status")!.removeFromParent()
            
            self.base.fillColor = .white
            self.assignedTo!.base.fillColor = .white
            
            self.assignedTo!.status.removeFromParent()
            self.assignedTo = nil
            
            self.assignButton.zRotation = 2 * CGFloat.pi
            
            if self.id!.contains(".40") {
                guard let slider = self.children.filter({ $0 is Slider }).first else { return }
                
                slider.isHidden = true
            }
        } else {
            let miniMap = AssignMap(node: self)
            self.addChild(miniMap)
        }
        
//        if self.id!.contains(".40") {
//            for sub in self.children {
//                if sub is Slider {
//                    (sub as! Slider).isHidden = self.assignedTo == nil
//                }
//            }
//        }
    }
    
    @objc fileprivate func disconnectButtonTapped(_ sender: MTKButton) {
        print("Disconnect Button Tapped")
        let disconnect = Disconnect(node: self)
        self.addChild(disconnect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBase(){
        
        self.base.fillColor = NSColor.white
        self.base.name = "BASE"
        self.addChild(self.base)
    }
    
    func drawTitleLabel(text:String){
        self.label = SKLabelNode(text:text)
        label?.fontSize = 20
        self.addChild(label!)
        
        if self.mainArgDicts.keys.count > 0 {
            label?.position = CGPoint(x: 0, y: -120)
        } else {
            label?.position = CGPoint(x: 0, y: 100)
        }
    }
    
    @objc func play(button:MTKButton){
        if self.assignedTo == nil {
            self.addChild(status)
            button.set(size: CGSize(width: 30, height: 30), image:"playGlyph")
            let scr = ScriptRunner(from: self)
            scr.script(id:button.name!)
            let resultMaker = ResultVisualization(from: self)
            resultMaker.getResults()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                button.set(size: CGSize(width: 20, height: 20), image:"playGlyph")
            }
        } else {
            self.assignedTo!.addChild(status)
            self.assignedTo!.playButton.set(size: CGSize(width: 30, height: 30), image:"playGlyph")
            let scr = ScriptRunner(from: self.assignedTo!)
            scr.script(id: self.assignedTo!.playButton.name!)
            let resultMaker = ResultVisualization(from: self.assignedTo!)
            resultMaker.getResults()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
                self.assignedTo!.playButton.set(size: CGSize(width: 20, height: 20), image:"playGlyph")
            }
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
        for item in result{
            item.changeBaseColor(color: NSColor(calibratedRed: 144/255.0, green: 238.0/255.0, blue: 144/255.0, alpha: 1.0))
        }
    }
}
