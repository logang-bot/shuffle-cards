//
//  BasicRequestFeatures.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 16/6/22.
//

import Foundation
import SVProgressHUD

// Functions to handle the API requests

extension ViewController {
    // Function to get the suffle id
    func requestShuffleId(url: String){
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        SVProgressHUD.show()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
    //        SVProgressHUD.dismiss()
            guard error == nil, let data = data else {return}
            
            do {

                if let shuffleData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    
                    self.shuffleId = shuffleData["deck_id"] as? String
                    
                    print(self.shuffleId!)
                    
                    self.fillImgUrlsArray(url: "https://deckofcardsapi.com/api/deck/\(self.shuffleId ?? "rj9kvfwagahv")/draw/?count=52")
                    
                }
                
            } catch let error{
                print(error)
                
            }
        }
        
        task.resume()
    }
    
    // Function to populate the array ot the imgs' urls
    func fillImgUrlsArray(url: String) {
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
    //    SVProgressHUD.show()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            SVProgressHUD.dismiss()
            guard error == nil, let data = data else {return}
            
            do {

                if let shuffleDataCards = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    
                    if let dataCards = shuffleDataCards["cards"] as? [[String:Any]]{
                        self.cardsUrls.removeAll()
                        
                        // Approach 2 (cache)
                        self.imgsCache = [UIImage?](repeating: nil, count: 52)
                        for card in dataCards {
                       
                            guard let cardUrl = card["image"] as? String else {continue}
                            self.cardsUrls.append(cardUrl)
                            
                        }
                    }
                    
                }
                DispatchQueue.main.sync {
                    self.cardsCollectionView.reloadData()
                }
                
            } catch let error{
                print(error)
                
            }
        }
        task.resume()
    }

}

