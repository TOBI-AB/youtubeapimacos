//
//  Helpers.swift
//  YoutubeProject
//
//  Created by Abdou on 11/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Foundation
import OAuthSwift

struct Youtube {
    static let clientID = "242373373621-o1lau8utkj8quoj0c0db60ri9a2etbf3.apps.googleusercontent.com"
    static let redirectURIScheme = "com.googleusercontent.apps.242373373621-o1lau8utkj8quoj0c0db60ri9a2etbf3"
    static let baseURL  = "https://www.googleapis.com/youtube/v3"
}


enum Path: String {
    case channelsPath      = "/channels"
    case videosPath        = "/videos"
    case searchPath        = "/search"
    case subscriptionsPath = "/subscriptions"
    case redirctURIPath    = ":/oauth2redirect"
    case googleOAuthPath   = "https://accounts.google.com/o/oauth2/auth"
    case tokenPath         = "https://accounts.google.com/o/oauth2/token"
    case refreshTokenPath  = "https://www.googleapis.com/oauth2/v4/token"
}

// MARK: - Methods
// Fetch Data from UserDefaults
func data(forKey key: String) -> Any? {

    guard let data = UserDefaults.standard.data(forKey: key) else {
        return nil
    }
    
    return NSKeyedUnarchiver.unarchiveObject(with: data)
}

//Add Parameters
func addingParameters(parameters: [String: Any], to string: String) -> String {
    
    guard var components = URLComponents(string: string) else { return "" }
    components.queryItems = parameters.map {  URLQueryItem(name: $0.key, value: "\($0.value)") }
    guard let url = components.url else { return ""}
    
    return url.absoluteString
}

// Convert country code -> flag
func emoji(countryCode: String) -> Character {
    let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
    
    var string = ""
    countryCode.uppercased().unicodeScalars.forEach {
        if let scala = UnicodeScalar(base + $0.value) {
            string.append(String(describing: scala))
        }
    }
    
    return Character(string)
}


//Abbreviated Int
extension Int {
    var abbreviated: String {
        let abbrev = "KMBTPE"
        return abbrev.characters.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}






































