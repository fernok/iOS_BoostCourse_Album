//
//  ShareImage.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/27.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import Foundation
import Photos
import UIKit

func shareImage(viewController: UIViewController, assetSet: [PHAsset], imageManager: PHCachingImageManager) {
    var imageToShare: [UIImage] = []
    for individualImage in assetSet {
        imageManager.requestImage(for: individualImage, targetSize: CGSize(width: individualImage.pixelWidth, height: individualImage.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: {
            image, _ in
            imageToShare.append(image!)
        })
    }
    
    let activityView: UIActivityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
    
    viewController.present(activityView, animated: true, completion: nil)
}
