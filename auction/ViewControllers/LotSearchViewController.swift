//
//  LotSearchViewController.swift
//  auction
//
//  Created by mathias cloet on 15/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit

class LotSearchViewController: LotViewController, UITextFieldDelegate    {
    
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBAction func searchLots(_ sender: Any) {
        LoadData()
    }
    
    override func LoadData() {
        let search = searchTermTextField.text
        AuctionAPI().getSearchLots(searchTerm: search ?? "", completion: { (data) in
            guard let data = data else { return }
            self.lots = data
            DispatchQueue.main.async {
                self.lotTableView.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar(text: "Zoek Loten")
        searchTermTextField?.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        LoadData()
        searchTermTextField?.resignFirstResponder()
        return true
    }
    
}
