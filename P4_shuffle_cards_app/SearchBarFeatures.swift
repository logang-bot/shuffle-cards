//
//  SearchBarFeatures.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 16/6/22.
//

import Foundation
import UIKit

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
        
        self.cardsCollectionView.reloadData()
        
    }
}


