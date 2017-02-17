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
            self.videoViewCount = video.viewCount + " views"
            self.videoLikeCount = video.likeCount + " 👍"
            self.publishedDate = "published at: " + (video.publishedDate.components(separatedBy: "T").first ?? "")
            self.fetchVideoThumbnailImage(imageURL: video.thumbnail)
        }
    }
    
    fileprivate func fetchVideoThumbnailImage(imageURL: String) {
        Alamofire.request(imageURL).validate().responseImage { (imageResponse: DataResponse<Image>) in
            guard (imageResponse.result.isSuccess) else {
                assertionFailure("Can't fetch video image\(imageResponse.result.error?.localizedDescription)")
                return
            }
            if let width = self.video.thmbnails["width"], let height = self.video.thmbnails["height"] {
                let imageSize = NSSize(width: CGFloat(width.numberValue), height: CGFloat(height.numberValue))
                
                if let image = imageResponse.result.value {
                    self.videoThumbnailImage = image.resize(toSize: imageSize)
                }
            }
        }
    }
    
}
























