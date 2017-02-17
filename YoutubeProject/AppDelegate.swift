//
//  AppDelegate.swift
//  YoutubeProject
//
//  Created by Abdou on 10/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Cocoa
import OAuthSwift
import SwiftyJSON
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var oauth2: OAuth2Swift = {
        let oauth = OAuth2Swift(consumerKey: Youtube.clientID, consumerSecret: "", authorizeUrl: "", accessTokenUrl: Path.tokenPath.rawValue, responseType: "")
        return oauth
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // UserDefaults.standard.removeObject(forKey: "tokendata")
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
            let codeArray = urlString.components(separatedBy: "=")
            let code = codeArray.last ?? ""
            exchangeAuthorizationCode(code)
        }
    }
    
    // MARK: - Exchange the code returned to authorization token
    fileprivate func exchangeAuthorizationCode(_ authorizationCode: String) {
        
        let parameters = ["code": authorizationCode, "client_id":Youtube.clientID, "redirect_uri": Youtube.redirectURIScheme.appending(Path.redirctURIPath.rawValue), "grant_type":"authorization_code"]
        let headers = ["Content-Type":"application/x-www-form-urlencoded", "Host":"accounts.google.com"]
        
        oauth2.startAuthorizedRequest(Path.tokenPath.rawValue, method: OAuthSwiftHTTPRequest.Method.POST, parameters: parameters, headers: headers, onTokenRenewal: nil, success: { (response: OAuthSwiftResponse) in
            
            let dict = ["data": response.data, "date": Date()] as [String : Any]
            UserDefaults.save(dict, forKey: "tokendata")
            let json = JSON(data: response.data)
            let accessToken = json["access_token"].stringValue
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "accessToken"), object: accessToken)
          
            UserDefaults.save(json["refresh_token"].stringValue, forKey: "refreshtoken")
            
        }) { (error: OAuthSwiftError) in
            print("error ------>\(error.localizedDescription)")
        }
    }
}




















