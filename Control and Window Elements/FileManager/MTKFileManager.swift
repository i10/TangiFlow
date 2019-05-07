import Foundation
import SpriteKit
import MultiTouchKitSwift
class MTKFileManager:SKNode,MTKButtonDelegate{
    var buttons:[MTKButton] = []
    var node:Node?
    override init() {
        super.init()
        var frame = SKShapeNode(rectOf: CGSize(width: 900, height: 500))
        frame.fillColor = NSColor.white
        self.addChild(frame)
//        var button = MTKButton(size: CGSize(width: 300, height: 300), image: "/Users/ppi/Desktop/lambo.jpg")
//        button.position = CGPoint.zero
//        self.addChild(button)
       // button.add(target: self, action: #selector(self.tap(button:)))
        
        let images = FileHandler.shared.getContent(of: FileHandler.shared.imageSource)
        for index in 0 ..< images.count{
            
            var i = index - 1
            var x = -300 + (i%3)*300
            var y = 140 - (i/3)*280
            var buttonHeight = 0
            var buttonWidth = 0
            let imageFile = NSImage(byReferencing: URL(fileURLWithPath: images[index].path))
            
            self.position = CGPoint.zero
            var factor = imageFile.size.height/imageFile.size.width
            
            
            if images[index].path != "/Users/ppi/Desktop/ImageSource/.DS_Store"{
                if imageFile.size.width > 200 || imageFile.size.height > 200{
                    
                    if imageFile.size.width > imageFile.size.height {
                        
                        var button = MTKButton(size: CGSize(width: 200, height: 200*factor), image: images[index].path)
                        button.name = images[index].path
                        self.addChild(button)
                        button.position = CGPoint(x: x, y: y)
                        button.add(target: self, action: #selector(self.tap(button:)))
                        
                        
                    } else {
                        
                        var button = MTKButton(size: CGSize(width: 200/factor, height: 200), image: images[index].path)
                        button.name = images[index].path
                        self.addChild(button)
                        button.position = CGPoint(x: x, y: y)
                        button.add(target: self, action: #selector(self.tap(button:)))
                        
                        
                    }
                    
                }else{
                   
                    var button = MTKButton(size: CGSize(width: 200, height: 200), image: images[index].path)
                    button.name = images[index].path
                    self.addChild(button)
                    button.position = CGPoint(x: x, y: y)
                    button.add(target: self, action: #selector(self.tap(button:)))
                    
                    }
                
            }
        }
    }
    
    
    
    @objc func tap(button:MTKButton){
        
        self.node?.sourceData?.removeFromParent()
        self.node?.sourceData = ImageTypeResultNode(url:button.name!)
        (self.node?.sourceData as! ImageTypeResultNode).url = button.name!
        self.node?.sourceData?.position = CGPoint(x: -300, y: 0)
        self.node?.addChild(self.node!.sourceData!)
        self.node!.sourceUrl = button.name!
        self.removeFromParent()
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
        
    }
    
}
