import Foundation
import SpriteKit
import MultiTouchKitSwift
class MTKFileManager:SKNode,MTKButtonDelegate{
    var buttons:[MTKButton] = []
    
    override init() {
        super.init()
        var frame = SKShapeNode(rectOf: CGSize(width: 900, height: 900))
        frame.fillColor = NSColor.white
        self.addChild(frame)
//        var button = MTKButton(size: CGSize(width: 300, height: 300), image: "/Users/ppi/Desktop/lambo.jpg")
//        button.position = CGPoint.zero
//        self.addChild(button)
       // button.add(target: self, action: #selector(self.tap(button:)))
        
        let images = FileHandler.shared.getContent(of: FileHandler.shared.imageSource)
        for index in 0 ..< images.count{
            print("IMAGR")
            var i = index - 1
            var x = -300 + (i%3)*300
            var y = 300 - (i/3)*300
            var buttonHeight = 0
            var buttonWidth = 0
            let imageFile = NSImage(byReferencing: URL(fileURLWithPath: images[index].absoluteString))
            
            self.position = CGPoint.zero
            var factor = imageFile.size.height/imageFile.size.width
            
            
            if images[index].path != "/Users/ppi/Desktop/ImageSource/.DS_Store"{
                if imageFile.size.width > 250 || imageFile.size.height > 250{
                    print("1")
                    if imageFile.size.width > imageFile.size.height {
                        print("2")
                        var button = MTKButton(size: CGSize(width: 250, height: 250*factor), image: images[index].absoluteString)
                        self.addChild(button)
                        button.position = CGPoint(x: x, y: y)
                        
                        
                    } else {
                        print("3")
                        var button = MTKButton(size: CGSize(width: 250/factor, height: 250), image: images[index].absoluteString)
                        self.addChild(button)
                        button.position = CGPoint(x: x, y: y)
                        
                        
                    }
                    
                }else{
                    print("4")
                    var button = MTKButton(size: CGSize(width: 200, height: 200), image: images[index].path)
                    self.addChild(button)
                    button.position = CGPoint(x: x, y: y)
                    
                    }
                
            }
        }
    }
    
    
    
    @objc func tap(button:MTKButton){
        print("i am pressed")
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
        
    }
    
}
