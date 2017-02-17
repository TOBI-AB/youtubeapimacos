//
//  NetworkService.swift
//  YoutubeProject
//
//  Created by Abdou on 16/02/2017.
//  Copyright © 2017 Abdou. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    static let shared = NetworkService()
    
    // Fetch Requested Data and Return JSON Object
    func fetchData(dataURL: String, with completion:@escaping (JSON) -> Void) {
        Alamofire.request(dataURL).validate().responseData { (dataResponse: DataResponse<Data>) in
            guard (dataResponse.result.isSuccess) else {
                let error = "Error fetching subscriptions: \(String(describing: dataResponse.result.error?.localizedDescription))"
                print(error)
                return
            }
            guard let data = dataResponse.result.value else {
                assertionFailure("No data returned for subscriptions")
                return
            }
            let json = JSON(data: data)
            completion(json)
        }
    }
}
