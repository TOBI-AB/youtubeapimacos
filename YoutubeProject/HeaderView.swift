//
//  HeaderView.swift
//  YoutubeProject
//
//  Created by Abdou on 17/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa

class HeaderView: NSView {
    
    @IBOutlet weak var channelTitleLabel: NSTextField!
    @IBOutlet weak var channelImageView: NSImageView!
    @IBOutlet weak var channelCountryLabel: NSTextField!
    @IBOutlet weak var viewCountLabel: NSTextField!
    @IBOutlet weak var subscriberCountLabel: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
    }
    
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    override func updateLayer() {
        self.layer?.backgroundColor = NSColor.darkGray.cgColor
    }
    
}
