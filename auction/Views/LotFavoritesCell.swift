//
//  LotFavoritesCell.swift
//  auction
//
//  Created by mathias cloet on 12/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit

class LotFavoritesCell: LotCell {
    
    @IBOutlet weak var lotMyBid: UILabel!
    
    var favLot: FavoriteLot?
    
    func setLotFavorite(favlot: FavoriteLot) {
        
        AuctionAPI().getLot(lotId: favlot.lotId, completion: { (data) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.setLot(lot: data)
            }
        })
        
        lotMyBid.text = "Mijn bod: € " + String(format: "%.2f", self.favLot?.myBid ?? 0)
    }
    
}
