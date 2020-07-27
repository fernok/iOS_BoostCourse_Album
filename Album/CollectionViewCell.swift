//
//  FriendsCollectionViewCell.swift
//  Album
//
//  Created by Hyuhng Min Kim on 2020/07/20.
//  Copyright © 2020 Hyuhng Min Kim. All rights reserved.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameAgeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
}


class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet var albumCoverImage: UIImageView!
    @IBOutlet var albumTitleLabel: UILabel!
    @IBOutlet var albumNumberLabel: UILabel!
}
