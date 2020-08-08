//
//  Delegates.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation

protocol OnTapDelegate: class {
    var onTap:((IndexPath) -> Void)? {get set}
}

protocol OnButtonPress: class {
    var onClick:(() -> ())? {get set}
}
