//
//  ViewModel.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/16/20.
//

import Foundation

class ViewModel {
    var per_page: Int = 0
    var total_results: Int = 0
    var url: String = ""
    var urlArray: [String] = []
    var videos: [Video] = []
    
    var videoURL: String = ""
    var imageURL: String = ""
    
   
    var video_files: [VideoFile] = []
    var video_pictures: [VideoPicture] = []
    
    var userName: String = ""
    var userNameArray: [String] = []
    
    var videoFileLinkArray: [String] = []
    var videoPicturesPictureURL: String = ""
    
    var videoData: VideoResults?
    let networkManager = Service.shared
    
    let videoName: String = ""
    
    func getVideoData(numberOfItems: Int) {
        
        networkManager.processVideoData(items: numberOfItems, completion: {(error, data) in
            if error != nil {
               print("Error occured with data")
            } else {
                
                self.per_page = data.perPage
                self.total_results = data.totalResults
                self.videos = data.videos
                
                for video in self.videos {
                    
                    self.userNameArray.append(video.user.name)
                    self.urlArray.append(video.url)
                    
                    let video_files = video.videoFiles
                    for videoFile in video_files {
                        if videoFile.quality == "hd" {
                            self.videoFileLinkArray.append(videoFile.link)
                            break
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "jsonInitData"), object: self)
            }
        })
    }
    
    private func getFormattedVideoTime(totalVideoDuration: Int) -> (hour: Int, minute: Int, seconds: Int){
        let seconds = totalVideoDuration % 60
        let minutes = (totalVideoDuration / 60) % 60
        let hours   = totalVideoDuration / 3600
        return (hours,minutes,seconds)
    }
}
