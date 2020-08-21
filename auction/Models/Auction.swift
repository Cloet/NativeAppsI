//
//  Auction.swift
//  auction
//
//  Created by mathias cloet on 02/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation

class Auction: Decodable {
    var id: Int = 0
    var title: String? = ""
    var overview: String? = ""
    var startDate: Date? = nil
    var endDate: Date? = nil
    var lots: String? = ""
    var images: [AuctionImage] = []
    var status : Int = 0
}
