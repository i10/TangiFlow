import Foundation
import SpriteKit
class Node: SKNode {
    var id:String?
    var maxInput:Int = 1
    var maxOutput:Int = 1
    var arcManager:ArcManager?
    var rotationMode:Bool = false
    override init() {
        super.init()
        
        self.id = UUID().uuidString
    }
    
    convenience init(position:CGPoint) {
        self.init()
        self.position = position
        self.arcManager = ArcManager(node:self)
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
    
    func getTempArc() -> Arc?{
        let arcs = self.arcManager!.inputArcs + self.arcManager!.outputArcs
        for arc in arcs{
            if arc.tempEdge != nil{
                return arc
            }
        }
        return nil
    }
    
   
    
}
