//
//  Videos.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/6/20.
//

import Foundation

// MARK: - Video Results
struct VideoResults: Codable {
    let page, perPage, totalResults: Int
    let url: String
    let videos: [Video]
    
    enum CodingKeys: String, CodingKey {
           case page
           case perPage = "per_page"
           case totalResults = "total_results"
           case url, videos
       }
}

// MARK: - Videos Model
struct Video: Codable {
    let id, width, height: Int
    let url: String
    let image: String
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]
    
    enum CodingKeys: String, CodingKey {
            case id, width, height, url, image, duration, user
            case videoFiles = "video_files"
            case videoPictures = "video_pictures"
        }
}


// MARK: - User
struct User: Codable {
    let id: Int
    let name: String
    let url: String
}


// MARK: - VideoFile
struct VideoFile: Codable {
    let id: Int
    let quality, fileType: String
    let width, height: Int?
    let link: String
    
    enum CodingKeys: String, CodingKey {
            case id, quality
            case fileType = "file_type"
            case width, height, link
        }
}


// MARK: - VideoPicture
struct VideoPicture: Codable {
    let id: Int
    let picture: String
    let nr: Int
}
