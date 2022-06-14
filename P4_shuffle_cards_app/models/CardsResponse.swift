//
//  CardsResponse.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 13/6/22.
//

import Foundation

struct CardsResponse: Decodable {
    let success: Bool
    let deckID: String
    let cards: [Card]
    let remaining: Int

    enum CodingKeys: String, CodingKey {
        case success
        case deckID = "deck_id"
        case cards, remaining
    }
}

struct Card: Decodable {
    let code: String
    let image: String
    let images: Images
    let value, suit: String
}

struct Images: Decodable {
    let svg: String
    let png: String
}
