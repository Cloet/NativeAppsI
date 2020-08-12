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
    
    func AddRefreshControl(action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Herladen")
        refreshControl.addTarget(self, action: action , for: .valueChanged)
        self.addSubview(refreshControl)
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

extension UITableViewDataSource {
    
    func dataAvailable(tableView: UITableView, hasData: Bool) -> Int {
        var numOfSections: Int = 0
        if (hasData) {
            numOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noData: UILabel = UILabel(frame: CGRect(x: 0, y:0, width: tableView.frame.width , height: tableView.frame.height))
            noData.text = "Geen data beschikbaar."
            noData.textAlignment = .center
            tableView.backgroundView = noData
            tableView.separatorStyle = .none
        }
        
        return numOfSections
    }
    
}
