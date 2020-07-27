//
//  ImageCollectionViewController.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/25.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var selectButtonItem: UIBarButtonItem!
    @IBOutlet var barButtonItem: UIBarButtonItem!
    var assetCollection: PHAssetCollection!
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "singleImageCell"
    let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
    
    // MARK:- Collection View Customization
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Wrong class cell dequeued")
        }
        
        let asset: PHAsset = fetchResult.object(at: indexPath.item)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: halfWidth, height: halfWidth), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.imageView?.image = image })
        
        return cell
    }

    // MARK:- Photos Methods
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }
        
        fetchResult = changes.fetchResultAfterChanges
        
//        if fetchResult.count == 0 {
//            self.navigationController?.popViewController(animated: true)
//        }
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
    func requestAssets(isChronological: Bool) {
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isChronological)]
        self.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
    
    @IBAction func changeOrderOfAssets(_ sender: UIBarButtonItem) {
        if sender.title == "최신순" {
            sender.title = "과거순"
            self.requestAssets(isChronological: false)
        }
        else {
            sender.title = "최신순"
            self.requestAssets(isChronological: true)
        }
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
    @IBAction func touchUpSelectButton(_ sender: UIBarButtonItem) {
        if sender.title == "선택" {
            sender.title = "취소"
            self.navigationItem.title = "항목 선택"
        }
        else {
            sender.title = "선택"
            self.navigationItem.title = self.assetCollection.localizedTitle
        }
    }

    // MARK:- Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestAssets(isChronological: true)
        
        PHPhotoLibrary.shared().register(self)
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        
//        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        
        flowLayout.estimatedItemSize = CGSize(width: halfWidth, height: halfWidth)
        
        self.collectionView.collectionViewLayout = flowLayout
        
        self.collectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
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
        guard let nextViewController: IndividualImageViewController = segue.destination as? IndividualImageViewController else {
            return
        }
        
        guard let cell: UICollectionViewCell = sender as? UICollectionViewCell else {
            return
        }
        
        guard let index: IndexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        
        nextViewController.asset = self.fetchResult[index.item]
        
    }

}
