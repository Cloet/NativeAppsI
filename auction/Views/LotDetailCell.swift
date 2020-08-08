//
//  LotDetailCell.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var lotDetailImage: UIImageView!
    
    func setImage(img: UIImage) {
        self.lotDetailImage.image = img
    }
    
}
