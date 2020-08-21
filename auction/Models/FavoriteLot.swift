//
//  FavoriteLot.swift
//  auction
//
//  Created by mathias cloet on 12/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift

class FavoriteLot: Object {
    @objc dynamic var lotId: Int = 0
    @objc dynamic var myBid: Double = 0.0
    @objc dynamic var imgRatio: Double = 0.0
    
    // Constructor
    convenience init(id: Int, bid: Double, ratio: Double) {
        self.init()
        self.lotId = id
        self.myBid = bid
        self.imgRatio = ratio
    }
    
}
