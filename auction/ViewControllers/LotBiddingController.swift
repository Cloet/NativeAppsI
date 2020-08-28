//
//  LotBiddingController.swift
//  auction
//
//  Created by mathias cloet on 10/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit
import RealmSwift

class LotBiddingController: UIViewController {
    
    // The current lot
    var lot: Lot?
    
    // Alle labels
    @IBOutlet weak var lotTitle: UILabel!
    @IBOutlet weak var lotOverview: UILabel!
    
    @IBOutlet weak var lotStartBid: UILabel!
    @IBOutlet weak var lotCurrentBid: UILabel!
    @IBOutlet weak var lotBid: UILabel!
    @IBOutlet weak var lotMinNextBid: UILabel!
    @IBOutlet weak var lotAmntOfBids: UILabel!
    @IBOutlet weak var lotBidError: UILabel!
    @IBOutlet weak var lotMyBid: UILabel!
    @IBOutlet weak var myBidStackView: UIStackView!
    
    // The field where the bid is entered
    @IBOutlet weak var myBid: UITextField!
    
    // Stackview
    @IBOutlet weak var lotStackView: UIStackView!
    
    // Callback to refresh the view from which it originated.
    var onCallback: ((Lot) -> (Void))?
    
    // Place a bid on the currently selected lot.
    @IBAction func placeBid(_ sender: Any) {
        
        var bid = 0.0
        if let txt = myBid?.text {
            bid = Double(txt) ?? 0
        }
        
        self.showYesNoAlert(title: "Bieden", message: "Bent u zeker dat u een bod van € " + String(format: "%2.f", bid) + " wilt plaatsen?", handlerYes: { [weak self] action in
            
            guard let self = self else {
                return
            }
            
            if let id = self.lot?.id {
                AuctionAPI().postLotBid(lotId: id, bid: bid, completion: { (data) in
                    guard let data = data else {return}

                    // Indicates succes
                    DispatchQueue.main.async {
                        if data.errorMessage.count == 0 {
                            // Save lot
                            self.lotBidError?.text = "Bod geplaatst."
                            
                            // toevoegen aan realm
                            self.lot?.updateFavoritedLotBid(bid: bid)
                            self.myBid.text = ""
                            self.RefreshLot()
                        } else {
                            self.lotBidError?.text = data.errorMessage
                        }
                    }
                })
            }
        }, handlerNo: nil)
        

    }
        
    // Huidig lot herladen
    func RefreshLot() {
        if let id = lot?.id {
            AuctionAPI().getLot(lotId: id, completion: { (data) in
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.lot = data
                    self.onCallback?(data)
                    self.setLotData()
                }
            })
        }
    }
        
    // Set all data of the currently selected lot.
    func setLotData() {
        lotTitle?.text = lot?.title
        lotOverview?.text = lot?.overview
        
        lotStartBid?.text = "€ " + String(format: "%.2f", lot?.openingsBid ?? 0)
        lotCurrentBid?.text = "€ " + String(format: "%.2f", lot?.currentBid ?? 0)
        lotBid?.text = "€ " + String(format: "%.2f", lot?.bid ?? 0)
        
        var nextBid = 0.0
        if (lot?.currentBid != lot?.openingsBid) {
            if let currBid = lot?.currentBid, let bid = lot?.bid {
                nextBid = currBid+bid
            }
        } else {
            nextBid = lot?.openingsBid ?? 0
        }
        
        lotMinNextBid?.text = "€ " + String(format: "%.2f", nextBid)
        
        lotAmntOfBids?.text = "\(lot?.amountOfBids ?? 0)"
        
        guard let lot = lot else {
            myBidStackView?.isHidden = true
            return
        }
        
        let favLot = lot.getFavoritedLot(lotId: lot.id)
        if (favLot != nil) {
            lotMyBid?.text = "€ " + String(format: "%.2f", favLot?.myBid ?? 0)
            myBidStackView?.isHidden = (favLot?.myBid == 0)
        } else {
            myBidStackView?.isHidden = true
        }
        
        lotStackView?.sizeToFit()
        lotStackView?.layoutIfNeeded()
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myBid?.delegate = self
        
        // Always do a refresh of the data
        // possible the highest bid has changed.
        RefreshLot()
        
        // Adds a done button to keyboard.
        myBid.addDoneButtonToKeyboard(myAction:  #selector(self.myBid.resignFirstResponder))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
       
    @objc func keyboardWillShow(sender: NSNotification) {
        lotOverview.numberOfLines = 5
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        lotOverview.numberOfLines = 0
    }
        
}

extension LotBiddingController: UITextFieldDelegate {
    
    // Only allow numbers.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet.decimalDigits
        let charset = CharacterSet(charactersIn: string)
        return allowedChars.isSuperset(of: charset)
    }
    
    
}
