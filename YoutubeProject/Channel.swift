//
//  Channel.swift
//  YoutubeProject
//
//  Created by Abdou on 18/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Channel: NSObject {
    
    var title           = String()
    var country         = String()
    var thumbnail       = String()
    var viewCount       = String()
    var commentCount    = String()
    var subscriberCount = String()
    var videoCount      = String()
    
    override init() { super.init() }
    
    convenience init(json: JSON) {
        self.init()
        
        guard let first = json["items"].arrayValue.first else { return }
        
        self.title           = first["snippet"]["title"].stringValue
        self.country         = first["snippet"]["country"].stringValue
        self.thumbnail       = first["snippet"]["thumbnails"]["high"]["url"].stringValue
        self.viewCount       = first["statistics"]["viewCount"].stringValue
        self.commentCount    = first["statistics"]["commentCount"].stringValue
        self.subscriberCount = first["statistics"]["subscriberCount"].stringValue
        self.videoCount      = first["statistics"]["videoCount"].stringValue
    }

}




































