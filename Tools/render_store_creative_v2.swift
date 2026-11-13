import AppKit
import CoreText
let root=URL(fileURLWithPath:FileManager.default.currentDirectoryPath)
let out=root.appendingPathComponent("AppStore/Creative-v2")
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
 NSGraphicsContext.saveGraphicsState();NSBezierPath(roundedRect:NSRect(x:0,y:0,width:w,height:h),xRadius:49,yRadius:49).addClip();image("Documentation/UIRefinement/"+file,NSRect(x:0,y:0,width:w,height:h));NSGraphicsContext.restoreGraphicsState();NSGraphicsContext.restoreGraphicsState()
}
func brand(_ light:Bool=true){label("Tideverse",80,57,37,light ? ink : navy,"Manrope-Bold");let p=NSBezierPath();p.move(to:NSPoint(x:80,y:123));p.line(to:NSPoint(x:1240,y:123));c(0xD9E7F3,0.25).setStroke();p.lineWidth=1;p.stroke()}
func render(_ path:String,_ width:Int=1320,_ height:Int=2868,_ draw:()->Void){let ctx=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!;NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(cgContext:ctx,flipped:true);ctx.translateBy(x:0,y:CGFloat(height));ctx.scaleBy(x:1,y:-1);draw();let im=NSBitmapImageRep(cgImage:ctx.makeImage()!);try! im.representation(using:.png,properties:[:])!.write(to:out.appendingPathComponent(path));NSGraphicsContext.restoreGraphicsState()}
let dest="iPhone-1320x2868/"
render(dest+"01-enter-the-story.png") {
 fill(NSRect(x:0,y:0,width:1320,height:2868),navy)
 scene("mira",400,1900)
 fade(NSRect(x:0,y:320,width:1320,height:700),navy,c(0x071427,0))
 fade(NSRect(x:0,y:1800,width:1320,height:750),c(0x071427,0),navy)
 fill(NSRect(x:0,y:0,width:1320,height:520),c(0x071427,0.35))
 brand();title("Step into", "another story.",160,185)
 label("Original worlds. Characters worth knowing.",84,590,34,muted)
 portrait("mira",-170,910,1000)
 fade(NSRect(x:0,y:1900,width:1320,height:450),c(0x071427,0),navy)
 phone("refined-01-discover.png",495,1170,740,-4)
 label("A world to explore.\nA story to make yours.",80,2490,39,ink,"Manrope-SemiBold",430)
}
render(dest+"02-meet-the-characters.png") {
 fill(NSRect(x:0,y:0,width:1320,height:2868),c(0x101D32))
 scene("seraphine",560,1330)
 fade(NSRect(x:0,y:510,width:1320,height:470),c(0x101D32),c(0x101D32,0))
 fade(NSRect(x:0,y:1470,width:1320,height:500),c(0x101D32,0),c(0x101D32))
 portrait("jonah",-230,770,900);portrait("elara",660,790,850);portrait("vera",265,660,900)
 brand();title("Not just faces.","Personalities.",165,166)
 label("Meet 40 original fictional AI characters.",84,560,34,muted)
 fade(NSRect(x:0,y:1690,width:1320,height:470),c(0x101D32,0),c(0x101D32))
 phone("refined-06-profile.png",500,1460,700,4)
 label("A curious mind.\nA different world.\nSomeone new\nto discover.",80,2140,44,ink,"Manrope-SemiBold",410)
}
render(dest+"03-start-a-conversation.png") {
 fill(NSRect(x:0,y:0,width:1320,height:2868),c(0x071B29))
 scene("vera",610,2258)
 fill(NSRect(x:0,y:610,width:1320,height:2258),c(0x071B29,0.33))
 fade(NSRect(x:0,y:550,width:1320,height:480),c(0x071B29),c(0x071B29,0))
 brand();title("A little hello.","A new world.",160,176)
 label("Talk with fictional AI characters.\nFollow your curiosity.",84,585,35,muted)
 portrait("vera",660,830,880)
 fade(NSRect(x:0,y:1510,width:1320,height:493),c(0x071B29,0),c(0x071B29))
 fill(NSRect(x:0,y:2003,width:1320,height:865),c(0x071B29))
 phone("refined-07-conversation.png",66,1090,760,-3)
 label("Meet Vera.\nFollow the mystery.",880,2380,34,ink,"Manrope-SemiBold",365)
}
render(dest+"04-keep-your-journeys.png") {
 fill(NSRect(x:0,y:0,width:1320,height:2868),c(0x101A2B))
 scene("luna",770,2098)
 fill(NSRect(x:0,y:770,width:1320,height:2098),c(0x071427,0.33))
 fade(NSRect(x:0,y:650,width:1320,height:650),c(0x101A2B),c(0x101A2B,0))
 brand();title("Some stories", "stay with you.",165,176)
 label("Your journeys, choices and saved moments.\nAlways a place to return to.",84,585,34,muted)
 portrait("luna",-190,1060,970)
 fade(NSRect(x:0,y:2060,width:1320,height:540),c(0x101A2B,0),c(0x101A2B))
 fill(NSRect(x:0,y:2600,width:1320,height:268),c(0x101A2B))
 phone("refined-04-journeys.png",500,1090,755,3)
 label("Return.\nRemember.\nRediscover.",80,2420,46,ink,"Manrope-SemiBold",400)
}
render("Preview.png",1584,860){for (i,name) in ["01-enter-the-story","02-meet-the-characters","03-start-a-conversation","04-keep-your-journeys"].enumerated(){image("AppStore/Creative-v2/"+dest+name+".png",NSRect(x:i*396,y:0,width:396,height:860))}}
print("Rendered v2: 4 posters + contact sheet")
