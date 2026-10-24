import Foundation
import AVFoundation
import AppKit
import CoreVideo
let output=URL(fileURLWithPath:"work/launch-film/silent.mp4")
let writer=try AVAssetWriter(outputURL:output,fileType:.mp4)
let input=AVAssetWriterInput(mediaType:.video,outputSettings:[AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:1280,AVVideoHeightKey:720,AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:7000000,AVVideoProfileLevelKey:AVVideoProfileLevelH264HighAutoLevel]])
input.expectsMediaDataInRealTime=false
let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput:input,sourcePixelBufferAttributes:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32ARGB,kCVPixelBufferWidthKey as String:1280,kCVPixelBufferHeightKey as String:720,kCVPixelBufferCGImageCompatibilityKey as String:true,kCVPixelBufferCGBitmapContextCompatibilityKey as String:true])
writer.add(input)
guard writer.startWriting() else {fatalError("writer: \(String(describing:writer.error))")}
writer.startSession(atSourceTime:.zero)
for i in 0..<450 {
    while !input.isReadyForMoreMediaData {Thread.sleep(forTimeInterval:0.002)}
    try autoreleasepool {
        let path=String(format:"work/launch-film/frames/%04d.jpg",i)
        guard let image=NSImage(contentsOfFile:path)?.cgImage(forProposedRect:nil,context:nil,hints:nil) else {fatalError("Missing \(path)")}
        var pixel:CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil,adaptor.pixelBufferPool!,&pixel)
        let buffer=pixel!
        CVPixelBufferLockBaseAddress(buffer,[])
        let context=CGContext(data:CVPixelBufferGetBaseAddress(buffer),width:1280,height:720,bitsPerComponent:8,bytesPerRow:CVPixelBufferGetBytesPerRow(buffer),space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.noneSkipFirst.rawValue)!
        context.draw(image,in:CGRect(x:0,y:0,width:1280,height:720))
        CVPixelBufferUnlockBaseAddress(buffer,[])
        guard adaptor.append(buffer,withPresentationTime:CMTime(value:Int64(i),timescale:30)) else {fatalError("Append: \(String(describing:writer.error))")}
    }
    if i%90==0 {print("Encoded \(i)/450")}
}
input.markAsFinished()
let done=DispatchSemaphore(value:0)
writer.finishWriting {done.signal()}
done.wait()
guard writer.status == .completed else {fatalError("\(String(describing:writer.error))")}
let video=AVURLAsset(url:output),music=AVURLAsset(url:URL(fileURLWithPath:"work/launch-film/score.wav"))
let composition=AVMutableComposition()
let duration=CMTime(value:450,timescale:30)
let vt=composition.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!
try vt.insertTimeRange(CMTimeRange(start:.zero,duration:duration),of:video.tracks(withMediaType:.video)[0],at:.zero)
let at=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
try at.insertTimeRange(CMTimeRange(start:.zero,duration:duration),of:music.tracks(withMediaType:.audio)[0],at:.zero)
let exporter=AVAssetExportSession(asset:composition,presetName:AVAssetExportPresetHighestQuality)!
exporter.outputURL=URL(fileURLWithPath:"launch-film/NOVA-ONE-launch.mp4")
exporter.outputFileType = .mp4
exporter.shouldOptimizeForNetworkUse=true
let mux=DispatchSemaphore(value:0)
exporter.exportAsynchronously {mux.signal()}
mux.wait()
guard exporter.status == .completed else {fatalError("Mux: \(String(describing:exporter.error))")}
print("COMPLETE: NOVA-ONE-launch.mp4, 1280x720, 30fps, 15s, audio")
