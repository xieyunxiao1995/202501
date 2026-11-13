import AppKit
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let out = root.appendingPathComponent("AppStore/Creative")
let W = 1320, H = 2868
func color(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) -> NSColor { NSColor(srgbRed:r,green:g,blue:b,alpha:1) }
let blue = color(0.42,0.77,1), white = color(0.96,0.98,1), muted = color(0.65,0.76,0.88)
func text(_ s:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ size:CGFloat,_ weight:NSFont.Weight,_ c:NSColor) {
 let p=NSMutableParagraphStyle(); p.lineSpacing=4
 (s as NSString).draw(in:NSRect(x:x,y:y,width:w,height:340),withAttributes:[.font:NSFont.systemFont(ofSize:size,weight:weight),.foregroundColor:c,.paragraphStyle:p])
}
func render(_ width:Int,_ height:Int,_ path:URL,_ body:()->Void) {
 let ctx=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
 NSGraphicsContext.saveGraphicsState(); let gc=NSGraphicsContext(cgContext:ctx,flipped:true); NSGraphicsContext.current=gc
 gc.cgContext.translateBy(x:0,y:CGFloat(height)); gc.cgContext.scaleBy(x:1,y:-1)
 body(); gc.flushGraphics(); NSGraphicsContext.restoreGraphicsState()
 let bitmap=NSBitmapImageRep(cgImage:ctx.makeImage()!)
 try! bitmap.representation(using:.png,properties:[:])!.write(to:path)
}
let entries:[(String,String,String,String,String,String)] = [
("01-discover","refined-01-discover.png","YOUR NEXT CHAPTER","A world of stories.\nA place for you.","Discover original worlds and characters\nwith stories worth stepping into.","EXPLORE ORIGINAL WORLDS"),
("02-characters","refined-06-profile.png","MEET THE CHARACTERS","New faces.\nUnforgettable stories.","Get to know fictional AI characters,\neach with a world of their own.","FIND YOUR NEXT CHARACTER"),
("03-conversation","refined-07-conversation.png","START A CONVERSATION","Every story starts\nwith a hello.","Meet a character. Ask a question.\nExplore the world behind the story.","CHAT WITH FICTIONAL AI"),
("04-journeys","refined-04-journeys.png","MAKE IT YOUR JOURNEY","Your choices.\nYour story to keep.","Return to your journeys and revisit\nthe moments you chose to save.","RETURN TO YOUR JOURNEYS")]
for (i,e) in entries.enumerated() {
 render(W,H,out.appendingPathComponent("iPhone-1320x2868/\(e.0).png")) {
  NSGradient(starting:color(0.025,0.065,0.13),ending:color(0.055,0.19,0.31))!.draw(in:NSRect(x:0,y:0,width:W,height:H),angle:75)
  // Delicate orbital lines connect the collection without competing with the UI.
  for j in 0..<3 { let p=NSBezierPath(ovalIn:NSRect(x:CGFloat(-470+j*95),y:CGFloat(1040+j*160),width:2100,height:2100)); blue.withAlphaComponent(0.08).setStroke();p.lineWidth=2;p.stroke() }
  text("TIDEVERSE",92,94,900,33,.bold,white)
  text(String(format:"%02d / 04",i+1),1080,100,180,25,.medium,muted)
  text(e.2,92,209,1140,26,.semibold,blue)
  text(e.3,88,276,1190,91,.bold,white)
  text(e.4,94,525,1150,35,.regular,muted)
  let screen=NSImage(contentsOf:root.appendingPathComponent("Documentation/UIRefinement/\(e.1)"))!
  let sw:CGFloat=864, sh:CGFloat=864*2622/1206, sx:CGFloat=(1320-sw)/2, sy:CGFloat=770
  let frame=NSRect(x:sx-15,y:sy-15,width:sw+30,height:sh+30)
  NSGraphicsContext.saveGraphicsState(); let shadow=NSShadow();shadow.shadowColor=NSColor.black.withAlphaComponent(0.6);shadow.shadowBlurRadius=50;shadow.shadowOffset=NSSize(width:0,height:20);shadow.set()
  color(0.22,0.34,0.46).setFill();NSBezierPath(roundedRect:frame,xRadius:62,yRadius:62).fill();NSGraphicsContext.restoreGraphicsState()
  NSGraphicsContext.saveGraphicsState();NSBezierPath(roundedRect:NSRect(x:sx,y:sy,width:sw,height:sh),xRadius:49,yRadius:49).addClip()
  screen.draw(in:NSRect(x:sx,y:sy,width:sw,height:sh),from:.zero,operation:.copy,fraction:1,respectFlipped:true,hints:[.interpolation:NSImageInterpolation.high])
  NSGraphicsContext.restoreGraphicsState()
  text(e.5,92,2722,1160,27,.semibold,blue)
 }
}
render(1320,717,out.appendingPathComponent("Preview.png")) {
 color(0.03,0.07,0.13).setFill();NSRect(x:0,y:0,width:1320,height:717).fill()
 for (i,e) in entries.enumerated() { NSImage(contentsOf:out.appendingPathComponent("iPhone-1320x2868/\(e.0).png"))!.draw(in:NSRect(x:i*330,y:0,width:330,height:717),from:.zero,operation:.copy,fraction:1,respectFlipped:true,hints:nil) }
}
print("Rendered 4 RGB iPhone posters and Preview.png")
