//
//  PostMessage.swift
//  auction
//
//  Created by mathias cloet on 10/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import RealmSwift

class PostMessage: Object, Decodable {
    @objc dynamic var message: String = ""
    @objc dynamic var errorMessage: String = ""
}
