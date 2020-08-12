//
//  extensions.swift
//  auction
//
//  Created by mathias cloet on 12/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

extension UITableView {
    
    func sizeHeaderToFit() {
        if let headerView = self.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            self.tableHeaderView = headerView
        }
    }
    
}

extension UIViewController {
    
    func setupNavBar(text: String) {

        let label = UILabel()
        label.text = text
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)

    }
    
}
