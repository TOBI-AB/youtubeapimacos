//
//  Video.swift
//  YoutubeProject
//
//  Created by Abdou on 16/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Video: NSObject {
    
    var title = String()
    var channelTitle = String()
    var publishedDate = String()
    var thumbnail = String()
    var thmbnails = [String: JSON]()
    var likeCount = String()
    var viewCount = String()
    var videoId = String()
    
    lazy var accessToken: String = {

        guard let accessTokenDict = data(forKey: "tokendata") as? [String: Any], let accessTokenData = accessTokenDict["data"] as? Data else {
            return ""
        }
        let json = JSON(data: accessTokenData)
        return json["access_token"].stringValue
    }()
    
    override init() {
        super.init()
    }
    
    convenience init(json: JSON) {
        self.init()

        self.title = json["snippet"]["title"].stringValue
        self.publishedDate = json["snippet"]["publishedAt"].stringValue
        self.thumbnail = json["snippet"]["thumbnails"]["high"]["url"].stringValue
        self.thmbnails = json["snippet"]["thumbnails"]["high"].dictionaryValue
        self.videoId = json["id"]["videoId"].stringValue
        
        self.getVideoDetails(videoId: self.videoId)
    }
    
    fileprivate func getVideoDetails(videoId: String) {
        let parameters = ["part": "snippet,statistics,contentDetails", "id":"\(videoId)", "access_token":self.accessToken] as [String: Any]
        let host = Youtube.baseURL.appending(Path.videosPath.rawValue)
        let videoDetailsURL = addingParameters(parameters: parameters, to: host)
        
        NetworkService.shared.fetchData(dataURL: videoDetailsURL) { (json: JSON) in
            
            guard let videoDetails = json["items"].arrayValue.first else { return }
            
            self.likeCount = videoDetails["statistics"]["likeCount"].stringValue
            self.viewCount = videoDetails["statistics"]["viewCount"].stringValue
        }
    }
}






























