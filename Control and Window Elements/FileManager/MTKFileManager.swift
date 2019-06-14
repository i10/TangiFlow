import Foundation
import SpriteKit
import MultiTouchKitSwift
class MTKFileManager:SKNode,MTKButtonDelegate{
    var buttons:[MTKButton] = []
    var node:Node?
   // var folders:Bool = true
    var folders:[MTKButton] = []
    var files:[MTKButton] = []
    var page:Int = 0
    var chuncked:[[URL]] = []
    var left = MTKButton(size: CGSize(width: 100, height: 40), label: "<")
    var right = MTKButton(size: CGSize(width: 100, height: 40), label: ">")
    var backButton = MTKButton(size: CGSize(width: 140, height: 40), label: "← Back")
    override init() {
        super.init()
        self.zPosition = 10
        var frame = SKShapeNode(rectOf: CGSize(width: 900, height: 500))
        frame.fillColor = SKColor.gray
        var close = MTKButton(size: CGSize(width: 100, height: 40), label: "Close")
        close.add(target: self, action: #selector(self.close(button:)))
        close.position = CGPoint(x: 400, y: -230)
        close.zPosition = 11
        self.addChild(close)
    
        self.addChild(frame)
//        var button = MTKButton(size: CGSize(width: 300, height: 300), image: "/Users/ppi/Desktop/lambo.jpg")
//        button.position = CGPoint.zero
//        self.addChild(button)
       // button.add(target: self, action: #selector(self.tap(button:)))
        
        self.drawFolders()
    }
    
    
    
    @objc func tap(button:MTKButton){
        
        self.node?.sourceData?.removeFromParent()
        self.node?.sourceData = ImageTypeResultNode(url:button.name!)
        (self.node?.sourceData as! ImageTypeResultNode).reloadImage(zoom: self.node!.zoomValue)
        (self.node?.sourceData as! ImageTypeResultNode).setSlider()
        (self.node?.sourceData as! ImageTypeResultNode).url = button.name!
        //self.node?.sourceData?.position = CGPoint(x: 0, y: -370)
        self.node?.addChild(self.node!.sourceData!)
        self.node!.sourceUrl = button.name!
        (self.node?.sourceData as! ImageTypeResultNode).setSlider()
        self.removeFromParent()
    }
    
    
    @objc func close(button:MTKButton){
        self.removeFromParent()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("decoder init is not implemented")
    }
    
    @objc func buttonTapped(button: MTKButton) {
       
        self.chuncked = FileHandler.shared.getContent(of: ( button.name!) ).filter{$0 != URL(fileURLWithPath: button.name!+"/.DS_Store")}.chunked(into: 6)
        self.drawImages()
 
    }
    
    func drawFolders(){
        self.cleanButtons()
        for item in self.folders{
            item.removeFromParent()
        }
        for item in self.files{
            item.removeFromParent()
        }
        self.files = []
        let images = FileHandler.shared.getContent(of: FileHandler.shared.imageSource).filter{$0 != URL(fileURLWithPath:"/Users/ppi/Desktop/ImageSource/.DS_Store")}
        self.page = 0
       
        for index in 0 ..< images.count{
            let i = index
            let x = -300 + (i%3)*300
            let y = 140 - (i/3)*250
           // self.position = CGPoint.zero
            let button = MTKButton(size: CGSize(width: 200, height: 200), image: "ffolder.png")
            self.folders.append(button)
            button.name = images[index].path
            let label = SKLabelNode(text: images[index].lastPathComponent)
            button.addChild(label)
            label.position.y = -120
            self.addChild(button)
            button.position = CGPoint(x: x, y: y)
            button.add(target: self, action: #selector(self.buttonTapped(button:)))
        }
    }
    
    func drawImages(){
        self.cleanButtons()
        for item in self.folders{
            item.removeFromParent()
        }
        for item in self.files{
            item.removeFromParent()
        }
        if self.chuncked.count > 1 {
            self.drawButtons()
        }
        for index in 0 ..< self.chuncked[self.page].count{
            //if self.chuncked[self.page][index].lastPathComponent != ".DS_Store"{
            let i = index
            let x = -300 + (i%3)*300
            let y = 180 - (i/3)*220
                var buttonHeight = 0
                var buttonWidth = 0
                let imageFile = NSImage(byReferencing: URL(fileURLWithPath: self.chuncked[self.page][index].path))
                
                //self.position = CGPoint.zero
                var factor = imageFile.size.height/imageFile.size.width
           
                if imageFile.size.width > 200 || imageFile.size.height > 200{
                    
                    if imageFile.size.width > imageFile.size.height {
                        
                        var button = MTKButton(size: CGSize(width: 200, height: 200*factor), image: self.chuncked[self.page][index].path)
                        self.files.append(button)
                        button.name = self.chuncked[self.page][index].path
                        self.addChild(button)
                        button.position = CGPoint(x: x, y: y)
                        button.add(target: self, action: #selector(self.tap(button:)))
                        
                        
                    } else {
                        
                        var button = MTKButton(size: CGSize(width: 200/factor, height: 200), image: self.chuncked[self.page][index].path)
                        self.files.append(button)
                        button.name = self.chuncked[self.page][index].path
                        self.addChild(button)
                        button.position = CGPoint(x: x, y: y)
                        button.add(target: self, action: #selector(self.tap(button:)))
                        
                        
                    }
                    
                }else{
                    
                    var button = MTKButton(size: CGSize(width: 200, height: 200), image: self.chuncked[self.page][index].path)
                    self.files.append(button)
                    button.name = self.chuncked[self.page][index].path
                    self.addChild(button)
                    button.position = CGPoint(x: x, y: y)
                    button.add(target: self, action: #selector(self.tap(button:)))
                    
                }
                
            //}
        }
    }
    func drawButtons(){
        self.left.name = "left"
        self.right.name = "right"
        self.backButton.name = "back"
        self.addChild(self.left)
        self.addChild(self.right)
        self.addChild(self.backButton)
        self.left.position = CGPoint(x: -60, y: -230)
        self.right.position = CGPoint(x: 60, y: -230)
        self.backButton.position = CGPoint(x: -380, y: -230)
        self.left.add(target: self, action: #selector(self.navButtons(button:)))
        self.right.add(target: self, action: #selector(self.navButtons(button:)))
        self.backButton.add(target: self, action: #selector(self.navButtons(button:)))
    }
    func cleanButtons(){
        self.left.removeFromParent()
        self.right.removeFromParent()
        self.backButton.removeFromParent()
    }
    
    @objc func navButtons(button:MTKButton){
        switch button.name {
        case "left":
            self.page -= 1
            if self.page < 0{
                self.page = self.chuncked.count-1
            }
            self.drawImages()
        case "right":
            self.page += 1
            if self.page > self.chuncked.count - 1 {
                self.page = 0
            }
            self.drawImages()
        default:
            self.drawFolders()
        }
    }
    
    
    
}
