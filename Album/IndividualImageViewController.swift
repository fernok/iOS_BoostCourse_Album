//
//  IndividualImageViewController.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/27.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import UIKit
import Photos

class IndividualImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var likeButton: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!
    var asset: PHAsset!
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
    
    // MARK:- Touch Up Methods
    @IBAction func touchUpShareButton(_ sender: UIBarButtonItem) {
//        shareImage(viewController: self, asset: asset)
        shareImage(viewController: self, assetSet: [asset], imageManager: imageManager)
    }
    
    @IBAction func touchUpTrashButton(_ sender: UIBarButtonItem) {
        let assetToDelete: PHAsset = self.asset
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([assetToDelete] as NSFastEnumeration)
        }, completionHandler: {
            didDeleteAsset, _ in
            if didDeleteAsset {
                OperationQueue.main.addOperation {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
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

        // Do any additional setup after loading the view.
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: {
            image, _ in
            self.imageView.image = image
        })
        
//        self.navigationItem.title = asset.creationDate.
        guard let date: Date = asset.creationDate else { return }
        let dateString: String = self.dateFormatter.string(from: date)
        let timeString: String = self.timeFormatter.string(from: date)
        
//        self.navigationItem.title = dateString
        self.navigationItem.titleView = setTitle(title: dateString, subtitle: timeString)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
