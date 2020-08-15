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
    
    var lot: Lot?
    
    @IBOutlet weak var lotTitle: UILabel!
    @IBOutlet weak var lotOverview: UILabel!
    
    @IBOutlet weak var lotStartBid: UILabel!
    @IBOutlet weak var lotCurrentBid: UILabel!
    @IBOutlet weak var lotBid: UILabel!
    @IBOutlet weak var lotMinNextBid: UILabel!
    @IBOutlet weak var lotAmntOfBids: UILabel!

    @IBOutlet weak var myBid: UITextField!
    @IBOutlet weak var lotBidError: UILabel!
    
    // Bieden
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
                            self.RefreshLot()
                        } else {
                            self.lotBidError?.text = data.errorMessage
                        }
                    }
                })
            }
        }, handlerNo: nil)
        

    }
    
    var onCallback: ((Lot) -> (Void))?
    
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
    
    func setLotData() {
        lotTitle?.text = lot?.title
        lotOverview?.text = lot?.overview
        
        lotStartBid?.text = "Openingsbod: € " + String(format: "%.2f", lot?.openingsBid ?? 0)
        lotCurrentBid?.text = "Huidig bod: € " + String(format: "%.2f", lot?.currentBid ?? 0)
        lotBid?.text = "Opbod: € " + String(format: "%.2f", lot?.bid ?? 0)
        
        var nextBid = 0.0
        if (lot?.currentBid != lot?.openingsBid) {
            if let currBid = lot?.currentBid, let bid = lot?.bid {
                nextBid = currBid+bid
            }
        } else {
            nextBid = lot?.openingsBid ?? 0
        }
        
        lotMinNextBid?.text = "Min. volgend bod: € " + String(format: "%.2f", nextBid)
        
        lotAmntOfBids?.text = "Aantal biedingen: \(lot?.amountOfBids ?? 0)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myBid?.delegate = self
        
        // Always do a refresh of the data
        // possible the highest bid has changed.
        RefreshLot()
    }
    
}

extension LotBiddingController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet.decimalDigits
        let charset = CharacterSet(charactersIn: string)
        return allowedChars.isSuperset(of: charset)
    }
    
}
