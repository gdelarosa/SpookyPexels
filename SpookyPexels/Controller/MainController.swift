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
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    let alert = UIAlertController(title: nil, message: "Loading 👹...", preferredStyle: .alert)
    
    let client = Service.shared
    let viewModel = ViewModel()
    var videoLinkArray:[String] = []
    var userNames: [String] = []
    var namesFromURL:[String] = []
    var numberOfItems = 15
    var videoPictureArray: [String] = []
   
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadActivityView()
        setNavigationBarTitle()
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
        collectionView.backgroundColor = .orange
      
        viewModel.getVideoData(numberOfItems: numberOfItems)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshView), name: NSNotification.Name(rawValue: "jsonInitData"), object: nil)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
      }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
      }
    
    // MARK: - Methods
    func networkCheck() throws {
        if !NetworkCheck.isConnectedToNetwork() {
            throw ErrorHandling.noInternet
        }
    }
    
    func setNavigationBarTitle() {
        self.title = "Welcome"
        UIView.animate(withDuration: 5) {
            self.navigationController?.navigationBar.frame = CGRect(x: 150, y: 300, width: 200, height: 20)
        }
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ShadowedGermanica", size: 45)!]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadActivityView() {
        self.loadingIndicator.isHidden = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshView() {
        userNames = viewModel.userNameArray
        
        namesFromURL.removeAll()
        for name in viewModel.urlArray {
            
            let nameString = name
            var clearNameFromURL = nameString.replacingOccurrences(of: "https://www.pexels.com/video/", with: "")
            clearNameFromURL = clearNameFromURL.replacingOccurrences(of: "-", with:" ")
            clearNameFromURL = clearNameFromURL.components(separatedBy: CharacterSet.decimalDigits).joined()
            clearNameFromURL = clearNameFromURL.replacingOccurrences(of: "/", with:"")
            namesFromURL.append(clearNameFromURL)
        }
        
        videoLinkArray = viewModel.videoFileLinkArray
        
        let thumbnails = viewModel.video_pictures
       
        if thumbnails.count > 0 {
            for thumb in thumbnails {
                if thumb.nr == 0 {
                    videoPictureArray.append(thumb.picture)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    
    // MARK:  - CollectionView Layout
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(270)))
            item.contentInsets.bottom = 16
            item.contentInsets.trailing = 16
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 32, leading: 16, bottom: 0, trailing: 0)
            
            return section
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.per_page
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
        
        let videoURLString = String(videoLinkArray[indexPath.row]) + String(".mp4")
        let videoURL = URL(string: videoURLString)
        
        cell.categoryLabel.text = userNames[indexPath.row]
        cell.titleLabel.text = namesFromURL[indexPath.row]
        cell.videoPlayerItem = AVPlayerItem.init(url: videoURL!)
       
        return cell
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

