//
//  ImproveRequestFeatures.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 16/6/22.
//

import Foundation
import SVProgressHUD

// Functions to handle the API requests with Network Manager
extension ViewController {
    
    // Function to get the suffle id
    func requestShuffleIdWithNetMan(url: String){
        guard let url = URL(string: url) else {return}
        
        SVProgressHUD.show()
        
        NetworkManager.shared.get(ShuffleDeck.self, from: url){result in
    
            switch result {
            case .success(let shuffleData):
                
                self.shuffleId = shuffleData.deckID
                print(self.shuffleId!)
                
                self.fillImgUrlsArrayWithNetMan(url: "https://deckofcardsapi.com/api/deck/\(self.shuffleId ?? "rj9kvfwagahv")/draw/?count=52")
                
            case .failure(let error):
                print(error)
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in print("OK")}))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    // Function to populate the array ot the imgs' urls
    func fillImgUrlsArrayWithNetMan(url: String){
        guard let url = URL(string: url) else {return}
        
        NetworkManager.shared.get(CardsResponse.self, from: url) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let shuffleDataCards):
                
                    let dataCards = shuffleDataCards.cards
                    self.cardsUrls.removeAll()
                
                    self.cardsData.removeAll()
                    
                    // Approach 2 (cache)
//                    self.imgsCache = [UIImage?](repeating: nil, count: 52)
                    
                    for card in dataCards {
                        let cardUrl = card.image
                        self.cardsUrls.append(cardUrl)
                        
                        // Storing in Cards array all the data of the card
                        self.cardsData.append(card)
                    }
//                DispatchQueue.main.sync {
                    self.cardsToShow = self.cardsData
                    self.cardsCollectionView.reloadData()
                    self.searchBar.isHidden = false
//                }
                
            case .failure(let error):
                print(error)
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in print("OK")}))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
