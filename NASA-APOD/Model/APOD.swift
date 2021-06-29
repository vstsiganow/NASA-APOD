//
//  APOD.swift
//  NASA-APOD
//
//  Created by vtsyganov on 20.06.2021.
//

import Foundation

struct APODResponse: Decodable {
    let data: [APOD]
}

struct APOD: Decodable {
    
    let copyright: String?
    let date: String
    let explanation: String
    let imageHDUrl: String?
    let imageUrl: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case copyright
        case date
        case explanation
        case imageHDUrl = "hdurl"
        case imageUrl = "url"
        case title
    }
    
    func getRightURL() -> URL {
        URL(string: imageHDUrl ?? imageUrl)!
    }

}
