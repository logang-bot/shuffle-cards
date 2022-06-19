//
//  ExtensionViewController.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 17/6/22.
//

import Foundation
import SVProgressHUD
import UIKit

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

// Collection View
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cardsUrls.count
//        return cardsData.count
        return cardsToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "MyCellTest", for: indexPath as IndexPath) as? CardCollectionViewCell ?? CardCollectionViewCell()
        
//        let card = cardsUrls[indexPath.row]
//        let card = cardsData[indexPath.row]
        let card = cardsToShow[indexPath.row]
        
        // Approach 1
        if let url = URL(string: card.image) {
            ImageManager.shared.loadImage(from: url){ result in
                switch result {
                case .success(let image):
                    cell.cardImageView.image = image
                case.failure(let error):
                    print(error)
                }
                
            }
//            cell.cardImageView.image = ImageManager(url: card.image).loadImage()
//            cell.cardImageView.load(url: url)
//            imgsCache.append(cell.cardImageView.image)
//            imgsCache[indexPath.row] = cell.cardImageView.image
        }

        // Approach 2 (with cache)
//        if let image = self.imgsCache?[indexPath.row] {
//            cell.cardImageView.image = image
//        }
//
//
//        else if let url = URL(string: card){
//            cell.cardImageView.load(url: url)
////            imgsCache.append(cell.cardImageView.image)
//            imgsCache?[indexPath.row] = cell.cardImageView.image
//        }
//
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Approach 1
//        let card = cardsUrls[indexPath.row]
//        let card = cardsData[indexPath.row]
        let card = cardsToShow[indexPath.row]


        if let url = URL(string: card.image){
            self.fullScreenImageView.load(url: url)
            self.fullScreenImageView.isHidden = false
        }
        
        // Approach 2 (with cache)
//        let card = cardsUrls[indexPath.row]
//
//        if imgsCache!.count >= cardsUrls.count  {
//            if let image = self.imgsCache?[indexPath.row] {
//                self.fullScreenImageView.image = image
//                self.fullScreenImageView.isHidden = false
//            }
//        }
//
//        else if let url = URL(string: card){
//            self.fullScreenImageView.load(url: url)
//            self.fullScreenImageView.isHidden = false
//        }
    }
}

// Search Bar
extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        cardsToShow = cardsData
        fullScreenImageView.image = nil
        self.fullScreenImageView.isHidden = true
        self.cardsCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            cardsToShow = cardsData
            self.cardsCollectionView.reloadData()
            fullScreenImageView.image = nil
            self.fullScreenImageView.isHidden = true
            return
        }
        
//        cardsToShow = cardsData.filter{card in
//            return card.suit.lowercased().contains(text.lowercased()) || card.value.lowercased().contains(text.lowercased())
//        }
        
        cardsToShow = cardsData.filter{card in
            return card.suit.lowercased().starts(with: text.lowercased()) || card.value.lowercased().starts(with: text.lowercased())
        }
        
        if cardsToShow.count == 0 {
            self.fullScreenImageView.image = UIImage(named: "no-found")
            self.fullScreenImageView.isHidden = false
        } else {
            fullScreenImageView.image = nil
            fullScreenImageView.isHidden = true
        }
        
        self.cardsCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text, !text.isEmpty else {
//            cardsToShow = cardsData
//            self.cardsCollectionView.reloadData()
//            return
//        }
//
//        cardsToShow = cardsData.filter{card in
//            return card.suit == text.uppercased()
//        }
//
//        self.cardsCollectionView.reloadData()
//
//    }
}


