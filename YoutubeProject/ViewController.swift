//
//  ViewController.swift
//  YoutubeProject
//
//  Created by Abdou on 10/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import OAuthSwift
import Alamofire
import SwiftyJSON

class ViewController: NSViewController {
    
    @IBOutlet weak var subscriptionsCollectionView: NSCollectionView!
    @IBOutlet weak var channelVideosCollectionView: NSCollectionView!
  
    var subscriptions = [Subscription]()
    var channelVideos = [Video]()
    
    // Fetch channel Videos
    lazy var channelId = String()
    lazy var accessToken = String()
    lazy var nextPageToken: String? = nil
    lazy var videosNextPageToken: String? = nil
    
    lazy var oauthAccessToken: OAuth2Swift = {
        let ouath = OAuth2Swift(consumerKey: Youtube.clientID, consumerSecret: "", authorizeUrl: Path.googleOAuthPath.rawValue, responseType: "code")
        return ouath
    }()
    
    lazy var oauthRefreshToken: OAuth2Swift = {
        let oauth = OAuth2Swift(consumerKey: Youtube.clientID, consumerSecret: "", authorizeUrl: "", accessTokenUrl: Path.refreshTokenPath.rawValue, responseType: "")
        return oauth
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "accessToken"), object: nil, queue: OperationQueue.main) { (notification:Notification) in
           
            if let object = notification.object as? String {
                self.accessToken = object
                self.fetchUserSubscriptions(object, tokenPage: self.nextPageToken)
            }
        }
        self.checkCredential()
        self.setupCollectionView()
        self.channelVideosCollectionView.dataSource = self
        self.channelVideosCollectionView.delegate = self
    }
    
    
    // MARK: - Check Credentials
    fileprivate func checkCredential() {
      
        // Check stored token
        guard let tokenData = UserDefaults.standard.data(forKey: "tokendata") else {
            // If there isn't not stored token -> Send Authorization to goole server
            youtubeAPIAuthorization()
            return
        }
        // User authorized -> Check if access-token key is expired -> Yes so Re-Authorize whit refresh token / No so Fetch User Subscriptions
        guard let tokenDataUnarchived = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? [String: Any] else {
            return
        }
        let json = JSON(data: tokenDataUnarchived["data"] as? Data ?? Data())
        //print(json)
        
        guard let date = tokenDataUnarchived["date"] as? Date else { return }
       
        // calculate the difference between Now and Date whene token was stored, then compare the result with expries_in value
        let tokenDateSinceNow = Date().timeIntervalSince(date)
        let expiresInDate = TimeInterval(json["expires_in"].doubleValue)

        switch tokenDateSinceNow {
       
        // Acces Token is expired so re-authorized with refresh token
        case let intervall where intervall >= expiresInDate:
            print(0, intervall)
            if let token = data(forKey: "refreshtoken") as? String, token != "" {
                self.refreshToken(token)
            }
            
        // Access Token is still valid so fetch User Subscriptions
        case let intervall where intervall < expiresInDate:
            print(1, intervall)
            self.accessToken = json["access_token"].stringValue
            self.fetchUserSubscriptions(self.accessToken, tokenPage: self.nextPageToken)

        default:
            break
        }
    }
    
    // Youtube API Authorization
    fileprivate func youtubeAPIAuthorization() {
        oauthAccessToken.authorize(withCallbackURL: Youtube.redirectURIScheme.appending(Path.redirctURIPath.rawValue),
                                   scope: "https://gdata.youtube.com", state: "",
                                   parameters: ["access_type":"offline"],
                                   headers: nil,
                                   success: { (cred: OAuthSwiftCredential, response: OAuthSwiftResponse?, _) in
                                    
        }) { (error: OAuthSwiftError) in
            print("Error authorization: \(error.localizedDescription)")
        }
    }
    
    // Refresh token
    fileprivate func refreshToken(_ token: String?) {
        guard  let token = token else {
            assertionFailure("invalid refresh token")
            return
        }

        let headers = ["Content-Type":"application/x-www-form-urlencoded", "Host":"accounts.google.com"]
        oauthRefreshToken.renewAccessToken(withRefreshToken: token, headers: headers, success: { (cred: OAuthSwiftCredential, response:OAuthSwiftResponse?, _) in
            
            if let response = response {
                let data = response.data
                let json = JSON(data: data)
                self.accessToken = json["access_token"].stringValue
                self.fetchUserSubscriptions(self.accessToken, tokenPage: self.nextPageToken)
                self.storeTokenData(data)
            }
        }) { (error: OAuthSwiftError) in
            print("Error renewing Access Token:", error.description)
            // If can't refresh toke -> user revoke access toke -> re-authorize
            self.youtubeAPIAuthorization()
        }
      
    }
    
    // Store Token Data in UserDefaults
    fileprivate func storeTokenData(_ tokenData: Data) {
        UserDefaults.standard.removeObject(forKey: "tokendata")
        let dict = ["data": tokenData, "date": Date()] as [String : Any]
        UserDefaults.save(dict, forKey: "tokendata")
    }
}




























