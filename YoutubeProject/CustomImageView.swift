//
//  CustomImageView.swift
//  YoutubeProject
//
//  Created by Abdou on 17/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa

class CustomImageView: NSImageView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    override func updateLayer() {
        //self.layer?.backgroundColor = NSColor.darkGray.cgColor
    }
    
}
