//
//  Auction.swift
//  auction
//
//  Created by mathias cloet on 02/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift

class Auction: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String? = ""
    @objc dynamic var overview: String? = ""
    @objc dynamic var startDate: Date? = nil
    @objc dynamic var endDate: Date? = nil
    @objc dynamic var lots: String? = ""
    var images: [AuctionImage] = []
    @objc dynamic var status : Int = 0
}
