//
//  ViewController+Extensions.swift
//  YoutubeProject
//
//  Created by Abdou on 12/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import Alamofire
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
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        return NSView()
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
                self.fetchChannelVideos(channelId: self.channelId, tokenPage: self.videosNextPageToken)
            } else {
                return
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        self.channelVideos.removeAll()
        self.channelVideosCollectionView.reloadData()
        guard let indexPath = indexPaths.first else { return }
        let subscription = self.subscriptions[indexPath.item]
        self.channelId = subscription.channelId
        fetchChannelVideos(channelId: self.channelId)
    }
}

// MARK: - Helpers
extension ViewController {
    
    // Fetch Subscriptions
    func fetchUserSubscriptions(_ accessToken: String, tokenPage: String? = "") {
        
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
            
            temp = json["items"].arrayValue.map { Video(json: $0) }
            
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
            layout.itemSize = CGSize(width: 60, height: 60)
            
            layoutVideos.scrollDirection = .vertical
            layoutVideos.sectionInset = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layoutVideos.itemSize = CGSize(width: 310, height: 300)
        }
    }
}




















































































