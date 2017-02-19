//
//  ChannelVideoItem.swift
//  YoutubeProject
//
//  Created by Abdou on 16/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import SwiftyJSON

class ChannelVideoItem: NSCollectionViewItem {
    
    // MARK: - Properties
    dynamic var videoTitle = String()
    dynamic var videoThumbnailImage: NSImage? = nil
    dynamic var videoViewCount = String()
    dynamic var videoLikeCount = String()
    dynamic var videoDislikeCount = String()
    dynamic var publishedDate = String()
    
    lazy var video = Video()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            guard let video = representedObject as? Video else {
                return
            }
            self.video = video
            self.videoTitle = video.title
            self.videoViewCount = video.viewCount != ""  ?  video.viewCount + " views" : ""
            self.videoLikeCount = (video.likeCount != "" && video.likeCount != "0")  ?  video.likeCount + " 👍" : ""
            self.videoDislikeCount = (video.dislikeCount != "" && video.dislikeCount != "0")  ?  video.dislikeCount + " 👎🏻" : ""
            let publishedDate = (video.publishedDate.components(separatedBy: "T").first ?? "")
            self.publishedDate =  "published at: " + publishedDate
            self.fetchVideoThumbnailImage(imageURL: video.thumbnail)
            /*print(publishedDate)
            let dateform = DateFormatter()
            dateform.dateStyle = .medium
            if let tt = dateform.date(from: publishedDate) {
                let tdt = Date.timeIntervalSince(tt)
                print("since now: \(tdt)")
            } else {
                print("z")
            }*/
        }
    }
    
    fileprivate func fetchVideoThumbnailImage(imageURL: String) {
        Alamofire.request(imageURL).validate().responseImage { (imageResponse: DataResponse<Image>) in
            guard (imageResponse.result.isSuccess) else {
                let error = "Can't fetch video image\(imageResponse.result.error?.localizedDescription)"
                print(error)
                //assertionFailure("Can't fetch video image\(imageResponse.result.error?.localizedDescription)")
                return
            }
            if let width = self.video.thmbnails["width"], let height = self.video.thmbnails["height"] {
                let imageSize = NSSize(width: CGFloat(width.numberValue)*0.9, height: CGFloat(height.numberValue)*0.9)
                
                if let image = imageResponse.result.value {
                    self.videoThumbnailImage = image.resize(toSize: imageSize)
                }
            }
        }
    }
    
}
























