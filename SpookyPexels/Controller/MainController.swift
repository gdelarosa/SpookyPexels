//
//  MainController.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/4/20.
//

import UIKit
import AVFoundation

class MainController: UICollectionViewController {

    // MARK: - Initializers
    init() {
        super.init(collectionViewLayout: MainController.createLayout())
    }
    
    // MARK: - Properties
    private let videoCellId = "video-cell-reuse-identifier"
    private let imageCellId = "image-cell-reuse-identifier"
    let client = Service.shared
    var per_page: Int = 0
    var total_results: Int = 0
    var url: String = ""
    var urlArray: [String] = []
    var videos: [Video] = []
    var video: VideoResults?
    var videoURL: String = ""
    var imageURL: String = ""

    var durationString: String = ""
    var durationArray: [String] = []
    var video_files: [VideoFile] = []
    var video_pictures: [VideoPicture] = []
    
    var userName: String = ""
    var userNameArray: [String] = []

    var videoFileLinkArray: [String] = []
    var videoPicturesPictureURL: String = ""
    var videoData: VideoResults?
    let videoName: String = ""
    
    var videoLinkArray:[String] = []
    var userNames: [String] = []
    var namesFromURL:[String] = []
    var visibleIP : IndexPath?
    var numberOfItems = 5
    var videoPictureArray: [String] = []
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Halloween"
        collectionView.backgroundColor = .white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: imageCellId)
        print("VDL")
        loadVideoData(numberOfItems: numberOfItems)
        
    }
    
    // MARK: - Methods
    
    func loadVideoData(numberOfItems: Int) {
         print("Loading data...")
         client.getVideoData(items: numberOfItems, completion: { (error,data) in
            if error != nil {
                print("Error parsing video data")
            } else {
               
                self.per_page = data.perPage
                self.total_results = data.totalResults
                self.videos = data.videos
                
                for video in self.videos {
                    self.userNameArray.append(video.user.name)
                    self.urlArray.append(video.url)
                    
                    let duration = self.getFormattedVideoTime(totalVideoDuration: video.duration)
                    if duration.hour != 0 {
                        self.durationString = String(duration.hour) + ":" + String(duration.minute) + ":" + String(duration.seconds)
                    } else if duration.minute != 0 {
                        self.durationString = String(duration.minute) + ":" + String(duration.seconds)
                    } else {
                        self.durationString = "0:" + String(duration.seconds)
                    }
                    self.durationArray.append(self.durationString)
                    
                    let video_files = video.videoFiles
                    for videoFile in video_files {
                        if videoFile.quality == "sd" {
                            self.videoFileLinkArray.append(videoFile.link)
                            break
                        }
                    }
                }
            }
            
        })
    }
    
    private func getFormattedVideoTime(totalVideoDuration: Int) -> (hour: Int, minute: Int, seconds: Int){
        let seconds = totalVideoDuration % 60
        let minutes = (totalVideoDuration / 60) % 60
        let hours   = totalVideoDuration / 3600
        return (hours,minutes,seconds)
    }
    

    
    // MARK:  - CollectionView Layout
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 2
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .paging
                
                return section
            } else if sectionNumber == 1 {
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
                item.contentInsets.bottom = 16
                item.contentInsets.trailing = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 32, leading: 16, bottom: 0, trailing: 0)
                
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
                item.contentInsets.bottom = 16
                item.contentInsets.trailing = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 32, leading: 16, bottom: 0, trailing: 0)
                return section
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return per_page
        }
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell

            let videoURLString = String(videoLinkArray[indexPath.row]) + String(".mp4")
            let videoURL = URL(string: videoURLString)
            
            cell.videoPlayerItem = AVPlayerItem.init(url: videoURL!)
            cell.videoView.backgroundColor = .clear
           
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
           
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

