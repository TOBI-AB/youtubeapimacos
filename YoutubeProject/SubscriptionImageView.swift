//
//  SubscriptionImageView.swift
//  YoutubeProject
//
//  Created by Abdou on 15/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa

class SubscriptionImageView: NSImageView {
    private var path: NSBezierPath = {
        let path = NSBezierPath()
        path.lineWidth = 2.0
        path.lineJoinStyle = .roundLineJoinStyle
        path.lineCapStyle = .roundLineCapStyle
        return path
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.darkGray.set()
        path.lineWidth = 2.0
        path.stroke()
    }
}
