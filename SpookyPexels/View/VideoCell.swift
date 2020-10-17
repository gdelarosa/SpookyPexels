//
//  VideoCell.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/7/20.
//

import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "video-cell-reuse-identifier"
    let videoView = UIView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    var videoURL: String = ""
    var pictureLink: String = ""
    var controllsAreShown = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    override func awakeFromNib() {
        self.setupMoviePlayer()
    }
    
    func setupMoviePlayer() {
        print("Setting up movie player")
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        
        if UIScreen.main.bounds.width == 375 {
            let widthRequired = self.frame.size.width - 20
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
        } else if UIScreen.main.bounds.width == 320 {
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
        } else {
            let widthRequired = self.frame.size.width
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
        }
        
        self.backgroundColor = .clear
        self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
    }
}

extension VideoCell {
    func configure() {
        videoView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(videoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        categoryLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.textColor = .placeholderText
        
        //imageView.layer.borderColor = UIColor.white.cgColor
        //videoView.layer.borderWidth = 1
        videoView.layer.cornerRadius = 4
        videoView.backgroundColor = UIColor.blue
        
        let spacing = CGFloat(10)
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

