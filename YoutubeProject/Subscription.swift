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
    
    init(json: JSON) {
        self.channelId = json["snippet"]["resourceId"]["channelId"].stringValue
        self.channelDescription = json["snippet"]["description"].stringValue
        self.title = json["snippet"]["title"].stringValue
        self.thumbnail = json["snippet"]["thumbnails"]["high"]["url"].stringValue
    }
    
    
    /*
     {
     "etag" : "\"uQc-MPTsstrHkQcRXL3IWLmeNsM\/VlkEuVjFTC85EV4WnnIfsWsWYbU\"",
     "kind" : "youtube#subscription",
     "id" : "hVSjdAS2TMk16myJMVXUFNUmai2NgCsAEMJGlpvBnLw",
     "contentDetails" : {
     "totalItemCount" : 3,
     "newItemCount" : 1,
     "activityType" : "all"
     },
     "snippet" : {
     "thumbnails" : {
     "default" : {
     "url" : "https:\/\/yt3.ggpht.com\/-eP_WvJ4YsOc\/AAAAAAAAAAI\/AAAAAAAAAAA\/lK8oDpFjgrs\/s88-c-k-no-mo-rj-c0xffffff\/photo.jpg"
     },
     "high" : {
     "url" : "https:\/\/yt3.ggpht.com\/-eP_WvJ4YsOc\/AAAAAAAAAAI\/AAAAAAAAAAA\/lK8oDpFjgrs\/s240-c-k-no-mo-rj-c0xffffff\/photo.jpg"
     },
     "medium" : {
     "url" : "https:\/\/yt3.ggpht.com\/-eP_WvJ4YsOc\/AAAAAAAAAAI\/AAAAAAAAAAA\/lK8oDpFjgrs\/s240-c-k-no-mo-rj-c0xffffff\/photo.jpg"
     }
     },
     "title" : "iOS Quickstart",
     "resourceId" : {
     "kind" : "youtube#channel",
     "channelId" : "UCKGSfaB16QoUPp82nkNA9qg"
     },
     "description" : "",
     "publishedAt" : "2017-02-12T14:12:36.000Z",
     "channelId" : "UCdUoJ3r8h6H7Q1iZotPqrJg"
     }
     }
     */

}
