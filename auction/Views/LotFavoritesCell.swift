//
//  LotFavoritesCell.swift
//  auction
//
//  Created by mathias cloet on 12/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class LotFavoritesCell: LotCell {
    
    var favLot: FavoriteLot?
    var onLotRemoved: (() -> ())?
    
    @IBOutlet weak var lotMyBid: UILabel!
    
    // Remove lot from realm
    @IBAction func removeLot(_ sender: Any) {
        
        let realm = try! Realm()
        
        
        guard let favLot = self.favLot else {
            fatalError("Geen geldig lot gevonden.")
        }
        
        try! realm.write {
            realm.delete(favLot)
        }
        
        onLotRemoved?()
    }
    
    func setLotFavorite(favlot: FavoriteLot) {
        self.favLot = favlot
        
        AuctionAPI().getLot(lotId: favlot.lotId, completion: { (data) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.setLot(lot: data)
            }
        })
        
        lotMyBid.text = "Mijn bod: € " + String(format: "%.2f", self.favLot?.myBid ?? 0)
    }
    
}
