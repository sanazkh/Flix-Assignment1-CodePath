//
//  Video.swift
//  Flix
//
//  Created by Sanaz Khosravi on 10/10/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import Foundation
class Video{
    var key : String
    var id: String
    
    init(dictionary: [String: Any]) {
        key = dictionary["key"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""
    }
    
    
    class func videoMovies(dictionaries: [[String: Any]]) -> [Video] {
        var videos: [Video] = []
        for dictionary in dictionaries {
            let video = Video(dictionary: dictionary)
            videos.append(video)
        }
        return videos
    }
    
}
