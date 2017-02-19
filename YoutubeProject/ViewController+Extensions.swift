//
//  ViewController+Extensions.swift
//  YoutubeProject
//
//  Created by Abdou on 12/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import SwiftyJSON

// NSCollectionView Protocols
extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.subscriptionsCollectionView:
            return self.subscriptions.count
        case self.channelVideosCollectionView:
            return self.channelVideos.count
        default:
            break
        }
        return Int()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        switch collectionView {
        case self.subscriptionsCollectionView:
            let item = collectionView.makeItem(withIdentifier: "SubscriptionItem", for: indexPath)
            item.representedObject = self.subscriptions[indexPath.item]
            return item
        case self.channelVideosCollectionView:
            let item = collectionView.makeItem(withIdentifier: "ChannelVideoItem", for: indexPath)
            item.representedObject = self.channelVideos[indexPath.item]
            return item
        default:
            break
        }
        
        return NSCollectionViewItem()
    }
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        
        switch collectionView {
        case self.subscriptionsCollectionView:
            
            if (indexPath.item == self.subscriptions.count - 3), self.nextPageToken != "" {
                self.fetchUserSubscriptions(self.accessToken, tokenPage: self.nextPageToken)
            } else {
                return
            }
        case self.channelVideosCollectionView:
            
            if (indexPath.item == self.channelVideos.count - 3), self.videosNextPageToken != "" {
                self.fetchChannelVideos(channelId: self.subscription.channelId, tokenPage: self.videosNextPageToken)
            } else {
                return
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {

        switch collectionView {
        case subscriptionsCollectionView:
            self.channelVideos.removeAll()
            self.channelVideosCollectionView.reloadData()
           
            guard let indexPath = indexPaths.first else {
                return
            }
            self.subscription = self.subscriptions[indexPath.item]
            self.view.window?.title = subscription.title

            fetchChannelVideos(channelId: self.subscription.channelId)
            fetchChannelDetails(channelId: self.subscription.channelId)
           
            self.channelVideosCollectionView.delegate = self

        case channelVideosCollectionView:
            guard let indexPath = indexPaths.first else {
                return
            }
            let selectedVideo = self.channelVideos[indexPath.item]
            let videoURL = URL(string: "https://www.youtube.com/watch?v=\(selectedVideo.videoId)")!
            print(videoURL)
            let _ = try? NSWorkspace.shared().open(videoURL, options: .default, configuration: [:])

        default:
            return
        }
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        
        if collectionView == self.channelVideosCollectionView {

            switch kind {
            case NSCollectionElementKindSectionHeader:
                let view =  collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: "HeaderView", for: indexPath) as! HeaderView
                self.setupHeaderView(view)
                return view
            default:
                break
            }
        }
        return NSView()
    }
}

extension ViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        switch collectionView {
        case self.channelVideosCollectionView:
            return NSSize(width: 0, height: 60)
        default:
            break
        }
        return NSSize.zero
    }
}

// MARK: - Helpers
extension ViewController {
    
    // fetch selected channel more details
    fileprivate func fetchChannelDetails(channelId: String) {

        let host = Youtube.baseURL.appending(Path.channelsPath.rawValue)
        let parameters = ["part":"snippet,contentDetails,statistics,status","id":channelId,"access_token":self.accessToken]
        let channelURLString = addingParameters(parameters: parameters, to: host)
        
        NetworkService.shared.fetchData(dataURL: channelURLString) { (json: JSON) in
            self.channel = Channel(json: json)
        }
    }
    
    // Setup ChannelVideosCollectionview HeaderView
    fileprivate func setupHeaderView(_ headerView: HeaderView) {
       
        headerView.channelTitleLabel.stringValue = self.channel.title
        if self.channel.country != "" {
            headerView.channelCountryLabel.stringValue = String(emoji(countryCode: self.channel.country))
        } else {
            headerView.channelCountryLabel.stringValue = ""
        }
        
        headerView.viewCountLabel.stringValue = (Int(self.channel.viewCount)?.abbreviated ?? "") + " views"
        headerView.subscriberCountLabel.stringValue = (Int(self.channel.subscriberCount)?.abbreviated ?? "") + " subscribers"
            
            Alamofire.request(self.channel.thumbnail).responseImage { (dataResponse: DataResponse<Image>) in
            if let image = dataResponse.result.value {
                headerView.channelImageView.image = image.resize(toSize: NSSize(width: 60.0, height: 60.0))
            }
        }

    }
    
    // Fetch Subscriptions
    func fetchUserSubscriptions(_ accessToken: String, tokenPage: String? = "") {
        print(accessToken)
        var tempArray = [Subscription]()
        
        let host = Youtube.baseURL.appending(Path.subscriptionsPath.rawValue)
        let parameters = ["part" : "snippet,contentDetails", "mine" : true, "maxResults" : "\(40)", "order" : "alphabetical","pageToken" : tokenPage ?? "", "access_token" : self.accessToken] as [String: Any]

        let subscriptionsURL = addingParameters(parameters: parameters, to: host)
        
        NetworkService.shared.fetchData(dataURL: subscriptionsURL) { (json: JSON) in
            
            self.nextPageToken = json["nextPageToken"].stringValue
            
            tempArray = json["items"].arrayValue.map { Subscription(json: $0) }
            self.subscriptions.append(contentsOf: tempArray)
            
            OperationQueue.main.addOperation {
                self.subscriptionsCollectionView.reloadData()
            }
        }
    }
    
    // Fetch Videos
    func fetchChannelVideos(channelId: String, tokenPage: String? = "") {
        
        let host = Youtube.baseURL.appending(Path.searchPath.rawValue)
        let parameters = ["part" : "snippet","channelId": channelId,"order" : "date","pageToken": tokenPage ?? "", "access_token" : self.accessToken] as [String: Any]
        let channelVideosURL = addingParameters(parameters: parameters, to: host)
        
        var temp = [Video]()
        NetworkService.shared.fetchData(dataURL: channelVideosURL) { (json: JSON) in
            
            temp = json["items"].arrayValue.map { Video(json: $0) }.filter { $0.videoId != ""}
            
            self.videosNextPageToken = json["nextPageToken"].stringValue
            self.channelVideos.append(contentsOf: temp)
            
            OperationQueue.main.addOperation {
                self.channelVideosCollectionView.reloadData()
            }
        }
    }
    
    // Setup subscriptions collectionView
    func setupCollectionView() {
        
        self.subscriptionsCollectionView.isSelectable = true
        self.channelVideosCollectionView.isSelectable = true
        
        if let layout = subscriptionsCollectionView.collectionViewLayout as? NSCollectionViewFlowLayout,
            let layoutVideos = channelVideosCollectionView.collectionViewLayout as? NSCollectionViewFlowLayout {
            
            layout.scrollDirection = .vertical
            layout.sectionInset = EdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            layout.itemSize = CGSize(width: 40, height: 40)
            
            layoutVideos.scrollDirection = .vertical
            layoutVideos.sectionHeadersPinToVisibleBounds = true
            layoutVideos.sectionInset = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layoutVideos.itemSize = CGSize(width: 320, height: 300)
            
        }
    }
}




















































































