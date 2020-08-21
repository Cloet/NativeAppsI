//
//  AuctionAPI.swift
//  auction
//
//  Created by mathias cloet on 02/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit


class AuctionAPI {
    
    let API_URL: String = "https://mathiascloet.com/api"
    let API_KEY: String = "AAEf47#g1H92jQyUnQWDlmubXc8YmVyuVTVV#oAI"
    
    func getDefaultGETRequest(url: String) -> URLRequest {
        
        guard let resourceUrl = URL(string: url) else { fatalError() }
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    // Generic get request
    func getRequest<T: Decodable>(type: T.Type, requestUrl: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        let request = getDefaultGETRequest(url: requestUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                let err = error ?? fatalError()
                completion(.failure(err))
                return
            }
            
            let result = Result {
                try AuctionJSONDecoder().decode(T.self, from: data)
            }
            completion(result)
            
        }
        task.resume()
    }
    
    // Gets a list of all auctions.
    func getAuctions(completion: @escaping ([Auction]?) -> Void) {
        
        let url : String = "\(API_URL)/Auctions/"
        _ = getRequest(type: [Auction].self, requestUrl: url) { (result) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    // Get a single lot.
    func getLot(lotId: Int, completion: @escaping (Lot?) -> Void) {
        let url : String = "\(API_URL)/Lots/\(lotId)"
        
        _ = getRequest(type: Lot.self, requestUrl: url) { (result) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    // Search for lots based on a searchterm.
    func getSearchLots(searchTerm: String, completion: @escaping ([Lot]?) -> Void) {
        let url : String = "\(API_URL)/Lots?search=\(searchTerm)"
        
        _ = getRequest(type: [Lot].self, requestUrl: url) { (result) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
            
        }
    }
    
    // Get all lots for an auction.
    func getLots(auctionId: Int, completion : @escaping ([Lot]?) -> Void) {
        let url : String = "\(API_URL)/Lots?auction=\(auctionId)"
        _ = getRequest(type: [Lot].self, requestUrl: url) { (result) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    // Get one lot image.
    func getLotImage(lotId: Int, imageId: Int, completion: @escaping (UIImage?) -> Void) {
        
        let url: String = "\(API_URL)/Lots/\(lotId)/images/\(imageId)"
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error downloading an image: \(String(describing: error))")
                completion(nil)
                return
            }
            completion(UIImage(data: data)!)
        }
        task.resume()
    }
    
    // Get all lot images
    func getLotImages(lot: Lot, completion: @escaping ([UIImage]?) -> Void ) {
        
        let group = DispatchGroup()
        var images: [UIImage] = []
        
        for image in lot.images {
            group.enter()
            getLotImage(lotId: image.lotID, imageId: image.id, completion: { (data) in
                guard let data = data else {return}
                images.append(data)
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    // Get one image of an auction.
    func getImage(auctionId: Int, imageId: Int, completion: @escaping (UIImage?) -> Void) {
        
        let url : String = "\(API_URL)/Auctions/\(auctionId)/images/\(imageId)"
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error downloading an image : \(String(describing: error))")
                completion(nil)
                return
            }
            completion(UIImage(data: data)!)
        }
        task.resume()
    }
    
    // Get all auction images.
    func getImages(auction: Auction, completion: @escaping ([UIImage]?) -> Void) {

        let group = DispatchGroup()
        var images: [UIImage] = []
        
        for image in auction.images {
            group.enter()
            getImage(auctionId: image.auctionID, imageId: image.id, completion: { (data) in
                guard let data = data else  { return}
                images.append(data)
                group.leave()
            } )
            
        }
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    // POST REQUESTS
    
    // Add values to a post
    func getPostBodyString(params:[String:Any]) -> Data? {
        var data = [String]()
        for (key, value) in params {
            data.append(key+"=\(value)")
        }
        return data.map { String($0) }
            .joined(separator: "&")
            .data(using: .utf8)
    }
    
    // Post a bid on a lot.
    func postLotBid(lotId: Int, bid: Double, completion: @escaping (PostMessage?) -> Void) {
        let url : String = "\(API_URL)/Lots/\(lotId)/Bid"
        let params : [String:Any] = [
            "newBid": bid
        ]
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "POST"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        request.httpBody = getPostBodyString(params: params)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print ("Error bidding on a lot. \(String(describing:error))")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let response = try decoder .decode(PostMessage.self, from: data)
                completion(response)
            } catch {
                completion(nil)
                print(error)
                return
            }
            
        }
        task.resume()
        
        
    }
    
}
