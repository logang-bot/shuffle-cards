//
//  ShuffleDeck.swift
//  P4_shuffle_cards_app
//
//  Created by Alvaro Choque on 13/6/22.
//

import Foundation

struct ShuffleDeck: Decodable {
    let success: Bool
    let deckID: String
    let remaining: Int
    let shuffled: Bool

    enum CodingKeys: String, CodingKey {
        case success
        case deckID = "deck_id"
        case remaining, shuffled
    }
}
