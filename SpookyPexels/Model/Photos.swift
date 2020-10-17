//
//  Media.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/6/20.

import Foundation

// MARK: - ImageResults
struct ImageResults: Codable {
    let totalResults, page, perPage: Int
    let photos: [Photo]
    let nextPage: String

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id, width, height: Int
    let url: String
    let photographer: String
    let photographerURL: String
    let photographerID: Int
    let src: Src
    let liked: Bool

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case src, liked
    }
}

// MARK: - Src
struct Src: Codable {
    let original, large2X, large, medium: String
    let small, portrait, landscape, tiny: String

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }
}

