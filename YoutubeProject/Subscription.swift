//
//  Subscription.swift
//  YoutubeProject
//
//  Created by Abdou on 12/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Subscription: NSObject {
    
    var channelId = String()
    var channelDescription = String()
    var title = String()
    var thumbnail = String()
    
    override init() {
        super.init()
    }
    
    convenience init(json: JSON) {
        self.init()
        self.channelId = json["snippet"]["resourceId"]["channelId"].stringValue
        self.channelDescription = json["snippet"]["description"].stringValue
        self.title = json["snippet"]["title"].stringValue
        self.thumbnail = json["snippet"]["thumbnails"]["high"]["url"].stringValue
    }
}
