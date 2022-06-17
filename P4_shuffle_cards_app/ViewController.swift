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
