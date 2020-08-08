//
//  LotImage.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift

class LotImage: Object, Decodable {
    @objc dynamic var lotID: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var imageLocation: String = ""
}
