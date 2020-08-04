//
//  AuctionCollectionCell.swift
//  auction
//
//  Created by mathias cloet on 03/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class AuctionCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var auctionCollectionImageView: UIImageView!
    
    func setImage(image : UIImage) {
        auctionCollectionImageView.image = image
    }
    
}

