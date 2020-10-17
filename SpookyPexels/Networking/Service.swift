//
//  Service.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/6/20.
//

import Foundation

typealias  JSONDataResult = (_ error: Error?, _ data: VideoResults) -> Void

// MARK: - Service class
class Service {
    
    // MARK: - Properties
    static let shared = Service()
    private let session: URLSession
    
    // MARK: - Initializer
    private init () {
        session = URLSession.shared
    }
    
    // MARK: - Methods
    // Processes the URL to produce readable data
    func processVideoData(items:Int, completion: @escaping JSONDataResult) {
        let videoURLString = "\(API.VIDEO_SEARCH_URL)?query=halloween&per_page=\(items)&page=1"
        
        let URL = NSURL(string: videoURLString)
        let request = NSMutableURLRequest(url: URL! as URL)
        request.httpMethod = API.GET
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.addValue(API.KEY, forHTTPHeaderField: API.HEADER)
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error != nil{
                print("Error with session response")
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                
                let videoData = try
                    decoder.decode(VideoResults.self, from: data)
                
                completion(nil, videoData)
                
            } catch let err {
                print("Error with decoding:", err)
            }
        }
        task.resume()
        
    }
}
