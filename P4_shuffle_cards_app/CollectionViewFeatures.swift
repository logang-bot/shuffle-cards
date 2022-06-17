//
//  CollectionViewFeatures.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 16/6/22.
//

import Foundation
import UIKit

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
