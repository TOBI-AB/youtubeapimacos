//
//  MainWindowController.swift
//  YoutubeProject
//
//  Created by Abdou on 15/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
     //   guard let screen = NSScreen.main() else { return }
     //   let screenFrame = screen.frame
        let origin = CGPoint(x: 0, y: 400)
        print(origin)
        
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.setFrame(NSRect(origin: origin, size: CGSize(width: 350, height: 900)), display: true)
    }

}
