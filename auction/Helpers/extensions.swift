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
    
    func AddRefreshControl(target: UIViewController, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Herladen")
        refreshControl.addTarget(target, action: action , for: .valueChanged)
        self.addSubview(refreshControl)
    }
    
}

extension UIButton {
    
    func BottomRightBorderRadius(radius: Int) {
        self.layer.mask = nil
        self.layer.cornerRadius = 0
        
        let rectShape = CAShapeLayer()

        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
    }
    
}

extension UIImageView {
    
    func TopLeftRightRadius(radii: Int) {
        
        self.layer.mask = nil
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topLeft , .topRight], cornerRadii: CGSize(width: radii, height: radii)).cgPath
        self.layer.mask = rectShape
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
    
    func showYesNoAlert(title: String, message: String, handlerYes: ((UIAlertAction) -> Void)? , handlerNo: ((UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: handlerYes))
        alert.addAction(UIAlertAction(title: "Nee", style: UIAlertAction.Style.default, handler: handlerNo))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
