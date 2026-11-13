import AppKit
import CoreText
let root=URL(fileURLWithPath:FileManager.default.currentDirectoryPath)
let out=root.appendingPathComponent("AppStore/Creative-v4")
for u in try! FileManager.default.contentsOfDirectory(at:out.appendingPathComponent("Fonts"),includingPropertiesForKeys:nil) where u.pathExtension == "ttf" { CTFontManagerRegisterFontsForURL(u as CFURL,.process,nil) }
func c(_ h:UInt32,_ a:CGFloat=1)->NSColor {NSColor(srgbRed:CGFloat((h>>16)&255)/255,green:CGFloat((h>>8)&255)/255,blue:CGFloat(h&255)/255,alpha:a)}
let ink=c(0xF5EDD8), azure=c(0x9DD9FA), muted=c(0xC4D3DF), navy=c(0x071427)
func fill(_ r:NSRect,_ col:NSColor){col.setFill();r.fill()}
func label(_ s:String,_ x:CGFloat,_ y:CGFloat,_ size:CGFloat,_ col:NSColor=ink,_ font:String="Manrope-Regular",_ width:CGFloat=1180) {
 let p=NSMutableParagraphStyle();p.lineBreakMode = .byWordWrapping
 let f=NSFont(name:font,size:size)!
 (s as NSString).draw(in:NSRect(x:x,y:y,width:width,height:500),withAttributes:[.font:f,.foregroundColor:col,.paragraphStyle:p,.kern:font.hasPrefix("Cormorant") ? -size*0.02 : 0])
}
func title(_ first:String,_ second:String,_ y:CGFloat=150,_ size:CGFloat=174){label(first,76,y,size,ink,"CormorantGaramond-SemiBold");label(second,76,y+size*0.95,size,azure,"CormorantGaramond-SemiBold")}
func image(_ path:String,_ rect:NSRect,_ cover:Bool=false) {
 let im=NSImage(contentsOf:root.appendingPathComponent(path))!;let sz=im.size
 if cover {let ratio=max(rect.width/sz.width,rect.height/sz.height); let r=NSRect(x:rect.midX-sz.width*ratio/2,y:rect.midY-sz.height*ratio/2,width:sz.width*ratio,height:sz.height*ratio);NSGraphicsContext.saveGraphicsState();NSBezierPath(rect:rect).addClip();im.draw(in:r,from:.zero,operation:.sourceOver,fraction:1,respectFlipped:true,hints:[.interpolation:NSImageInterpolation.high]);NSGraphicsContext.restoreGraphicsState()}
 else {im.draw(in:rect,from:.zero,operation:.sourceOver,fraction:1,respectFlipped:true,hints:[.interpolation:NSImageInterpolation.high])}
}
func asset(_ id:String,_ kind:String)->String { let p="Tideverse/Resources/Assets.xcassets/\(id)_\(kind).imageset";let a=try! FileManager.default.contentsOfDirectory(atPath:root.appendingPathComponent(p).path);return p+"/"+a.first(where:{$0.hasSuffix("png") || $0.hasSuffix("jpg")})! }
func fade(_ rect:NSRect,_ top:NSColor,_ bottom:NSColor){NSGradient(starting:top,ending:bottom)!.draw(in:rect,angle:90)}
func scene(_ id:String,_ y:CGFloat,_ h:CGFloat) {image(asset(id,"scene"),NSRect(x:0,y:y,width:1320,height:h),true)}
func portrait(_ id:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat) {image(asset(id,"portrait"),NSRect(x:x,y:y,width:w,height:w*4/3))}
func phone(_ file:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ angle:CGFloat=0){
 let h=w*2622/1206
 NSGraphicsContext.saveGraphicsState();let ctx=NSGraphicsContext.current!.cgContext;ctx.translateBy(x:x+w/2,y:y+h/2);ctx.rotate(by:angle*CGFloat.pi/180);ctx.translateBy(x:-w/2,y:-h/2)
 let r=NSRect(x:-12,y:-12,width:w+24,height:h+24)
 NSGraphicsContext.saveGraphicsState();let sh=NSShadow();sh.shadowColor=c(0x000000,0.65);sh.shadowBlurRadius=44;sh.shadowOffset=NSSize(width:12,height:28);sh.set();c(0x26374B).setFill();NSBezierPath(roundedRect:r,xRadius:60,yRadius:60).fill();NSGraphicsContext.restoreGraphicsState()
 NSGraphicsContext.saveGraphicsState();NSBezierPath(roundedRect:NSRect(x:0,y:0,width:w,height:h),xRadius:49,yRadius:49).addClip();image(file.hasPrefix("AppStore/") ? file : "Documentation/UIRefinement/"+file,NSRect(x:0,y:0,width:w,height:h));NSGraphicsContext.restoreGraphicsState();NSGraphicsContext.restoreGraphicsState()
}
func brand(_ light:Bool=true){label("Tideverse",80,57,37,light ? ink : navy,"Manrope-Bold");let p=NSBezierPath();p.move(to:NSPoint(x:80,y:123));p.line(to:NSPoint(x:1240,y:123));c(0xD9E7F3,0.25).setStroke();p.lineWidth=1;p.stroke()}
func render(_ path:String,_ width:Int=1320,_ height:Int=2868,_ draw:()->Void){let ctx=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!;NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(cgContext:ctx,flipped:true);ctx.translateBy(x:0,y:CGFloat(height));ctx.scaleBy(x:1,y:-1);draw();let im=NSBitmapImageRep(cgImage:ctx.makeImage()!);try! im.representation(using:.png,properties:[:])!.write(to:out.appendingPathComponent(path));NSGraphicsContext.restoreGraphicsState()}
func centered(_ s:String,_ y:CGFloat,_ size:CGFloat,_ col:NSColor=ink,_ font:String="Manrope-Bold") {
 let p=NSMutableParagraphStyle();p.alignment = .center;p.lineBreakMode = .byWordWrapping
 (s as NSString).draw(in:NSRect(x:50,y:y,width:1220,height:500),withAttributes:[.font:NSFont(name:font,size:size)!, .foregroundColor:col,.paragraphStyle:p,.kern: -size*0.025])
}
func heading(_ a:String,_ b:String,_ sub:String){centered(a,110,112,c(0xFAFCFF));centered(b,245,112,c(0x79C8FF));centered(sub,432,38,c(0xB9CDE2),"Manrope-Regular")}
func background(_ id:String){
 fill(NSRect(x:0,y:0,width:1320,height:2868),c(0x040A16))
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current!.compositingOperation = .sourceOver
 let im=NSImage(contentsOf:root.appendingPathComponent(asset(id,"scene")))!
 im.draw(in:NSRect(x:-500,y:0,width:2600,height:2868),from:.zero,operation:.sourceOver,fraction:0.13,respectFlipped:true,hints:nil)
 NSGraphicsContext.restoreGraphicsState()
 fade(NSRect(x:0,y:0,width:1320,height:900),c(0x040A16),c(0x040A16,0))
}
func device(_ file:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ angle:CGFloat=0,_ opacity:CGFloat=1){
 let h=w*2622/1206
 NSGraphicsContext.saveGraphicsState();let ctx=NSGraphicsContext.current!.cgContext
 ctx.setAlpha(opacity);ctx.translateBy(x:x+w/2,y:y+h/2);ctx.rotate(by:angle*CGFloat.pi/180);ctx.translateBy(x:-w/2,y:-h/2)
 let metal=NSRect(x:-24,y:-24,width:w+48,height:h+48)
 NSGradient(colors:[c(0x87A3B9),c(0x23354C),c(0x6C8AAA),c(0x15243C)])!.draw(in:NSBezierPath(roundedRect:metal,xRadius:120,yRadius:120),angle:40)
 c(0x020407).setFill();NSBezierPath(roundedRect:NSRect(x:-15,y:-15,width:w+30,height:h+30),xRadius:112,yRadius:112).fill()
 NSGraphicsContext.saveGraphicsState();NSBezierPath(roundedRect:NSRect(x:0,y:0,width:w,height:h),xRadius:100,yRadius:100).addClip();image(file.hasPrefix("AppStore/") ? file : "Documentation/UIRefinement/"+file,NSRect(x:0,y:0,width:w,height:h));NSGraphicsContext.restoreGraphicsState()
 // The device's hardware island occupies the empty status-bar center.
 c(0x010204).setFill();NSBezierPath(roundedRect:NSRect(x:w*0.355,y:25,width:w*0.29,height:w*0.07),xRadius:w*0.035,yRadius:w*0.035).fill()
 c(0x152339).setFill();NSBezierPath(ovalIn:NSRect(x:w*0.605,y:25+w*0.017,width:w*0.034,height:w*0.034)).fill()
 NSGraphicsContext.restoreGraphicsState()
}
func floatingPortrait(_ id:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat) {
 // Clip at the canvas bottom rather than introduce a rectangular torso seam.
 portrait(id,x,y,w)
}
func focus(_ file:String,_ src:CGRect,_ rect:NSRect) {
 let data=try! Data(contentsOf:root.appendingPathComponent("Documentation/UIRefinement/"+file));let rep=NSBitmapImageRep(data:data)!;let crop=rep.cgImage!.cropping(to:src)!
 let im=NSImage(cgImage:crop,size:NSSize(width:crop.width,height:crop.height))
 NSGraphicsContext.saveGraphicsState();let sh=NSShadow();sh.shadowColor=c(0x000000,0.65);sh.shadowBlurRadius=40;sh.shadowOffset=NSSize(width:0,height:22);sh.set();c(0x142C47).setFill();NSBezierPath(roundedRect:rect,xRadius:38,yRadius:38).fill();NSGraphicsContext.restoreGraphicsState()
 NSGraphicsContext.saveGraphicsState();NSBezierPath(roundedRect:rect,xRadius:38,yRadius:38).addClip();im.draw(in:rect,from:.zero,operation:.sourceOver,fraction:1,respectFlipped:true,hints:nil);NSGraphicsContext.restoreGraphicsState()
}
let dest="iPhone-1320x2868/"
render(dest+"01-chat-with-ai.png") {
 background("mira")
 heading("Chat with AI.","Meet someone new.","40 fictional characters. Different personalities to discover.")
 device("refined-02-chats.png",95,695,970,-5)
 floatingPortrait("mira",480,1275,1200)
}
render(dest+"02-meet-jonah.png") {
 background("jonah")
 heading("Meet Jonah.","Make the first move.","Get to know a character, then start chatting.")
 device("AppStore/Creative-v4/SourceScreens/jonah-profile.png",175,685,970)
}
render(dest+"03-a-real-exchange.png") {
 background("mira")
 heading("Your words.","Their personality.","A two-way conversation with a fictional AI character.")
 device("deepseek-live-reply.png",175,685,970)
 floatingPortrait("mira",620,1870,970)
}
render(dest+"04-find-your-next-chat.png") {
 background("rowan")
 heading("So many voices.","So much to say.","Choose a fictional AI character and start a conversation.")
 device("refined-02-chats.png",175,685,970)
 focus("refined-02-chats.png",CGRect(x:65,y:1638,width:1080,height:355),NSRect(x:54,y:1835,width:1212,height:398))
}
render("Preview.png",1584,860){for (i,name) in ["01-chat-with-ai","02-meet-jonah","03-a-real-exchange","04-find-your-next-chat"].enumerated(){image("AppStore/Creative-v4/"+dest+name+".png",NSRect(x:i*396,y:0,width:396,height:860))}}
print("Rendered chat-focused v4")
