//
//  IndividualImageViewController.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/27.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import UIKit
import Photos

class IndividualImageViewController: UIViewController, UIScrollViewDelegate, PHPhotoLibraryChangeObserver {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var likeButton: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!
    var asset: PHAsset!
    var assetIsFavorite: Bool!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "a hh:mm:ss"
        return formatter
    }()
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @objc func checkIfAssetIsFavorite() {
        if self.assetIsFavorite {
            self.likeButton.image = UIImage(systemName: "heart.fill")
        }
        else {
            self.likeButton.image = UIImage(systemName: "heart")
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("changed")
    }
    
    // MARK:- Touch Up Methods
    @IBAction func touchUpShareButton(_ sender: UIBarButtonItem) {
//        shareImage(viewController: self, asset: asset)
        shareImage(viewController: self, assetSet: [asset], imageManager: imageManager)
    }
    
    @IBAction func touchUpTrashButton(_ sender: UIBarButtonItem) {
        deleteImage(viewController: self, assetSet: [self.asset])
    }
    
    @IBAction func touchUpFavoriteButton(_ sender: UIBarButtonItem) {
        self.assetIsFavorite = !self.assetIsFavorite
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.asset)
            request.isFavorite = self.assetIsFavorite
        }, completionHandler: nil)
        
        checkIfAssetIsFavorite()
    }
    
    // MARK:- Set Title and Subtitle
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }

    // MARK:- Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: {
            image, _ in
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        })
        
        guard let date: Date = self.asset.creationDate else {
            fatalError("Date not available")
        }
        let dateString: String = self.dateFormatter.string(from: date)
        let timeString: String = self.timeFormatter.string(from: date)
        
        self.navigationItem.titleView = setTitle(title: dateString, subtitle: timeString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.assetIsFavorite = self.asset.isFavorite
        
        checkIfAssetIsFavorite()
    }
}
