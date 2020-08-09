//
//  AuctionImage.swift
//  auction
//
//  Created by mathias cloet on 03/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift

class AuctionImage: Object, Decodable {
    @objc dynamic var auctionID: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var imageLocation: String = ""
    @objc dynamic var aspectRatio: Double = 1.0
}
