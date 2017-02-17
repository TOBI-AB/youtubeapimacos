//
//  Extensions.swift
//  YoutubeProject
//
//  Created by Abdou on 12/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa

// MARK: UsefDefaults
extension UserDefaults {
    static func save(_ object: Any, forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: key)
        self.standard.synchronize()
    }
}
// MARK: - NSImage
extension NSImage {
    
    func resize(toSize size: NSSize) -> NSImage! {
        let destSize = size
        let newImage = NSImage(size: destSize)
        
        newImage.lockFocus()
        self.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, self.size.width, self.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1), respectFlipped: false, hints: nil)
        
        newImage.unlockFocus()
        newImage.size = destSize
        
        guard let data = newImage.tiffRepresentation else {
            return nil
        }
        
        return NSImage(data: data)
    }
    
    func roundCorners(width: CGFloat = 192, height: CGFloat = 192) -> NSImage {
        let xRad = width / 2
        let yRad = height / 2
        let existing = self
        let esize = existing.size
        let newSize = NSMakeSize(esize.width, esize.height)
        let composedImage = NSImage(size: newSize)
        
        composedImage.lockFocus()
        let ctx = NSGraphicsContext.current()
        ctx?.imageInterpolation = NSImageInterpolation.high
        
        let imageFrame = NSRect(x: 0, y: 0, width: width, height: height)
        let clipPath = NSBezierPath(roundedRect: imageFrame, xRadius: xRad, yRadius: yRad)
        clipPath.windingRule = NSWindingRule.evenOddWindingRule
        clipPath.addClip()
        
        let rect = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        self.draw(at: NSZeroPoint, from: rect, operation: .sourceOver, fraction: 1)
        composedImage.unlockFocus()
        
        return composedImage
    }
}



























