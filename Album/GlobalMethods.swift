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

func shareImage(viewController: UIViewController, asset: PHAsset, imageManager: PHCachingImageManager) {
    var assetImage: UIImage = UIImage()
    imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: {
        image, _ in
        assetImage = image!
    })
    let imageToShare: [UIImage] = [assetImage]
    let activityView: UIActivityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
    
    viewController.present(activityView, animated: true, completion: nil)
}
