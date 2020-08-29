//
//  LotDetailController.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit
import RealmSwift

class LotDetailController: UIViewController {
    
    var lot: Lot?
    var images: [UIImage] = []
    
    // Refresh callback
    var onRefresh: (() -> ())?
    
    // Tableview
    @IBOutlet weak var lotDetailTableview: UITableView!
    
    // Title + overview
    @IBOutlet weak var lotTitleLabel: UILabel!
    @IBOutlet weak var lotOverviewLabel: UILabel!

    // Labels amnt of bids
    @IBOutlet weak var lotOpeningsBid: UILabel!
    @IBOutlet weak var lotHighestBid: UILabel!
    @IBOutlet weak var lotBid: UILabel!
    @IBOutlet weak var lotMinBid: UILabel!
    @IBOutlet weak var lotAmntBids: UILabel!
    @IBOutlet weak var lotMyBid: UILabel!
    
    // Hidden if no bid is made.
    @IBOutlet weak var lotStackViewMyBid: UIStackView!
    
    // Main Stackview
    @IBOutlet weak var lotVerticalStackView: UIStackView!
    
    // Button
    @IBOutlet weak var lotBidButton: RoundedButton!
    @IBOutlet weak var lotFavoriteButton: RoundedButton!
    
    // Toggle favorited status
    @IBAction func toggleFavorited(_ sender: Any) {
        toggleFavoriet()
        onRefresh?()
    }
    
    // When bid button is clicked
    @IBAction func bidOnLot(_ sender: Any) {
        self.performSegue(withIdentifier: "showLotBid", sender: self)
    }
    
    // Navigate to biddingcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LotBiddingController {
            controller.lot = self.lot
            controller.onCallback = { [weak self] lot in
                self?.lot = lot
                self?.setupLot()
                self?.onRefresh?()
            }
        }        
    }
    
    // Change the text of the favoritedbutton.
    func favorietButtonLabel(persisted: Bool) {
        var msg = "Toevoegen aan favorieten"
        
        if (persisted) {
            msg = "Verwijder van favorieten"
        }
        
        lotFavoriteButton.setTitle(msg, for: .normal)
    }
    
    // Saves a new item to favorited or removes an existing one.
    func toggleFavoriet() {
        guard let lot = self.lot else {
            return
        }
        
        if (lot.alreadyPersisted()) {
            if (!lot.highestBidder()) {
                lot.deleteFavorite()
                favorietButtonLabel(persisted: false)
            } else {
                self.showOKAlert(title: lot.title ?? "Lot", message: "Kan dit lot niet verwijderen. U bent de hoogste bieder.")
            }
        } else {
            self.lot?.persistToRealm()
            self.showOKAlert(title: self.lot?.title ?? "Lot", message: "Lot toegevoegd aan favorieten.")
            favorietButtonLabel(persisted: true)
        }
    }
    
    // Setup the text of all the labels and retrieve images.
    func setupLot() {
        lotTitleLabel.text = lot?.title
        lotOverviewLabel.text = lot?.overview
        
        lotOpeningsBid.text = "€ " + String(format: "%.2f", lot?.openingsBid ?? 0)
        lotHighestBid.text = "€ " + String(format: "%.2f", lot?.currentBid ?? 0)
        lotBid.text = "€ " + String(format: "%.2f", lot?.bid ?? 0)
        lotAmntBids.text = "\(lot?.amountOfBids ?? 0)"
        
        var nextBid = 0.0
        if let currentBid = lot?.currentBid, let openingsbid = lot?.openingsBid {
            if (lot?.amountOfBids == 0) {
                nextBid = openingsbid
            } else {
                if let bid = lot?.bid {
                    nextBid = currentBid+bid
                }
            }
        }
        lotMinBid.text = "€ " + String(format: "%.2f", nextBid)
        
        lotBidButton.layer.cornerRadius = 5
        
        guard let lot = lot else {
            return
        }
        
        AuctionAPI().getLotImages(lot: lot, completion: { (data) in
            guard let data = data else {return}
            self.images = data
            DispatchQueue.main.async {
                self.lotDetailTableview.reloadData()
                self.lotDetailTableview.sizeHeaderToFit()
            }
        })
        
        favorietButtonLabel(persisted: lot.alreadyPersisted())
        
        let favLot = lot.getFavoritedLot(lotId: lot.id)
        if (favLot == nil) {
            lotStackViewMyBid.isHidden = true
        } else {
            lotMyBid?.text = "€ " + String(format: "%.2f", favLot?.myBid ?? 0)
            lotStackViewMyBid.isHidden = (favLot?.myBid ?? 0 == 0)
        }
        
        lotVerticalStackView.sizeToFit()
        lotVerticalStackView.layoutIfNeeded()
    }
    
    // Called when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLot()
        
        lotDetailTableview.AddRefreshControl(target: self, action: #selector(self.refresh(sender:)))
        lotDetailTableview.delegate = self
        lotDetailTableview.dataSource = self
        lotDetailTableview.separatorStyle = .none
    }
    
    // When changing from portrait to landscape on ipad -> tableviewheader doesn't display properly
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.setupLot()
    }
    
    @objc func refresh(sender: UIRefreshControl?) {
        setupLot()
        sender?.endRefreshing()
    }
        
}

extension LotDetailController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ratio = self.lot?.images[indexPath.row].aspectRatio ?? 1.0
        
        var newHeight = CGFloat(tableView.bounds.width * CGFloat(ratio))
             
        if newHeight > 600 {
            newHeight = 600
        }
        
        return newHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let img = images[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotDetailCell") as! LotDetailCell
        
        cell.setImage(img: img)
    
        return cell
    }
    
}
