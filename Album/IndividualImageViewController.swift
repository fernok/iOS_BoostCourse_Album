//
//  IndividualImageViewController.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/27.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import UIKit
import Photos

class IndividualImageViewController: UIViewController {
    
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
        print(dateString)
        print(timeString)
        self.navigationItem.title = dateString
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
