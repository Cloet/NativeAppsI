//
//  RoundedButton.swift
//  auction
//
//  Created by mathias cloet on 11/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    func setup() {
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.link
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
}
