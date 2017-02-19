//
//  SubscriptionItem.swift
//  YoutubeProject
//
//  Created by Abdou on 12/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage

class SubscriptionItem: NSCollectionViewItem {
    
    dynamic var image: NSImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            if let subscription = representedObject as? Subscription {
               self.fetchSubscriptionThumbnail(subscription.thumbnail)
            }
        }
    }
    
    fileprivate func fetchSubscriptionThumbnail(_ thumbnailURL: String) {
        Alamofire.request(thumbnailURL).responseImage { (dataResponse: DataResponse<Image>) in
            if let image = dataResponse.result.value {
                self.image = image.roundCorners(width: 240, height: 240)//resize(toSize: NSSize(width: 60.0, height: 60.0))
            }
        }
    }
}
