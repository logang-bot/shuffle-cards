//
//  ViewController.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 9/6/22.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shuffleId: String?
    var cardsUrls: [String] = []
    var cardsData: [Card] = []
    var cardsToShow: [Card] = []
    let fullScreenImageView: UIImageView = UIImageView()
    
    // Approach 2 (with cache)
    var imgsCache: [UIImage?]?
//    var imgsCache: [UIImage?] = [UIImage?](repeating: nil, count: 52)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsCollectionView.delegate =  self
        cardsCollectionView.dataSource = self
        
        searchBar.delegate = self
        
        let uiNib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        cardsCollectionView.register(uiNib, forCellWithReuseIdentifier: "MyCellTest")
        
        searchBar.showsCancelButton = true
        searchBar.isHidden = true
        
        // Setting constraints for fullScreenImageView
        setupFullScreenImage()
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        self.fullScreenImageView.isHidden = true
    }
    
    func setupFullScreenImage(){
        let margins = view.layoutMarginsGuide
        view.addSubview(fullScreenImageView)
        
        fullScreenImageView.isUserInteractionEnabled = true
        fullScreenImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        fullScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        fullScreenImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 100).isActive = true
        fullScreenImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -100).isActive = true
        
        fullScreenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        fullScreenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        fullScreenImageView.isHidden = true
    }

    @IBAction func shuffleButton(_ sender: Any) {
        self.requestShuffleIdWithNetMan(url: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1")
        
//        self.requestShuffleId(url: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1")
    }
    
}

// Functions to handle the API requests with Network Manager
extension ViewController {
    
    // Function to get the suffle id
    func requestShuffleIdWithNetMan(url: String){
        guard let url = URL(string: url) else {return}
        
        SVProgressHUD.show()
        
        NetworkManager.shared.get(ShuffleDeck.self, from: url){result in
            
//            SVProgressHUD.dismiss()
            
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

// Functions to handle the API requests
/*
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
*/

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            cardsToShow = cardsData
            self.cardsCollectionView.reloadData()
            return
        }
        
        cardsToShow = cardsData.filter{card in
            return card.suit == text.uppercased()
        }
        
        if cardsToShow.count == 0 {return}
        
        self.cardsCollectionView.reloadData()
        
    }
}

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
        if let url = URL(string: card.image){
            cell.cardImageView.load(url: url)
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
