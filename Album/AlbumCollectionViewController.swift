//
//  AlbumCollectionViewController.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/25.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import UIKit
import Photos

class AlbumCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var albumFetchResult: PHFetchResult<PHAssetCollection>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "albumCell"
    
    
    // MARK:- Collection View Customization
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumFetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! AlbumCollectionViewCell
        
        cell.albumTitleLabel.text = albumFetchResult[indexPath.item].localizedTitle
        cell.albumNumberLabel.text = String(albumFetchResult[indexPath.item].estimatedAssetCount)
        
        let albumAssetCollection: PHAssetCollection = albumFetchResult.object(at: indexPath.item)
        let albumCoverImageFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: albumAssetCollection, options: nil)
        let albumCoverImageAsset: PHAsset = albumCoverImageFetchResult.object(at: 0)
        
        imageManager.requestImage(for: albumCoverImageAsset, targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.albumCoverImage?.image = image})
        
        return cell
    }
    
    
    // MARK:- Photos Methods
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: albumFetchResult) else { return }
        
        albumFetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
    func requestCollection() {
        //print("reached")
        self.albumFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    }

    
    // MARK:- Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
            self.collectionView.reloadData()
        case .denied:
            print("접근 불가")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                print("request sent")
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                case .denied:
                    print("사용자가 허용하지 않음")
                default:
                    print("default")
                    break
                }
            })
        case .restricted:
            print("접근 제한")
        @unknown default:
            break
        }
        
        PHPhotoLibrary.shared().register(self)
        
        //self.requestCollection()
        
        //print("fetched album number: " + String(albumFetchResult.count))
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        
        flowLayout.estimatedItemSize = CGSize(width: halfWidth, height: halfWidth)
        
        self.collectionView.collectionViewLayout = flowLayout
        
        self.collectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadSections(IndexSet(0...0))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: ImageCollectionViewController = segue.destination as? ImageCollectionViewController else {
            return
        }
        
        guard let cell: UICollectionViewCell = sender as? UICollectionViewCell else {
            return
        }
        
        guard let index: IndexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        
        nextViewController.assetCollection = self.albumFetchResult[index.item]
        
    }

}
