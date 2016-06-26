//
//  APIClient.swift
//  KooKoo
//
//  Created by Channa Karunathilake on 6/25/16.
//  Copyright © 2016 KooKoo. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class APIClient {

    static let shared = APIClient()

    typealias TrackingResponse = (response: AnyObject?, error: NSError?) -> Void

    private let kBaseURL = "http://hackathonapi.azurewebsites.net/api"

    func sendLocation(location: CLLocation, completion: TrackingResponse) {

        let params: [String: AnyObject] = ["Latitude": location.coordinate.latitude,
                                           "Longitude": location.coordinate.longitude,
                                           "Heading": location.course,
                                           "Speed": location.speed,
                                           "Timestamp": Int(location.timestamp.timeIntervalSince1970 * 1000),
                                           "UserToken": "1"]
        
        Alamofire.request(.POST, kBaseURL + "/Tracking", parameters: params, encoding: .JSON, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .Success(let result):
                    completion(response: result, error: nil)
                case .Failure(let error):
                    completion(response: nil, error: error)
                }
        }
    }
}