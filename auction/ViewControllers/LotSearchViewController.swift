//
//  LotSearchViewController.swift
//  auction
//
//  Created by mathias cloet on 15/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit

// Search the API for lots.
class LotSearchViewController: LotViewController, UITextFieldDelegate    {
    
    // Field with searchterm
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBAction func searchLots(_ sender: Any) {
        LoadData()
    }
    
    // Search for lots based on a searchterm.
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
    
    // On enter.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        LoadData()
        searchTermTextField?.resignFirstResponder()
        return true
    }
    
}
