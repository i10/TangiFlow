import Foundation
import SpriteKit
import MultiTouchKitSwift
class MTKFileManager:SKNode,MTKButtonDelegate{
    override init() {
        super.init()
        var frame = SKShapeNode(rectOf: CGSize(width: 800, height: 365))
        frame.fillColor = NSColor.white
        self.addChild(frame)
    }
    
    
    //    convenience init(textField:NSTextField) {
    //        self.init()
    //        self.activeTextInput = textField
    //    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
        
    }
    
}
