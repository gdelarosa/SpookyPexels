//
//  Service.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/6/20.
//

import Foundation

typealias  JSONDataResult = (_ error: Error?, _ data: VideoResults) -> Void
typealias  JSONImageResult = (_ error: Error?, _ data: ImageResults) -> Void

class Service {
    
    static let shared = Service()
    private let session: URLSession
    
    private init () {
        session = URLSession.shared
    }
    
    
    func getVideoData(items:Int, completion: @escaping JSONDataResult) {
        let videoURLString = "https://api.pexels.com/videos/search?query=halloween&per_page=\(items)&page=1"
       
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
    
    func getImageData(items:Int, completion: @escaping JSONImageResult) {
        let imageURLString = "https://api.pexels.com/v1/search?query=halloween&per_page=\(items)&page=1"
       
        let URL = NSURL(string: imageURLString)
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
                
                let imageData = try
                    decoder.decode(ImageResults.self, from: data)
                
                completion(nil, imageData)
                
            } catch let err {
                print("Error with decoding:", err)
            }
        }
        task.resume()
        
    }
}
