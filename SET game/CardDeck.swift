//
//  CardDeck.swift
//  SET game
//
//  Created by Igor Shelginskiy on 4/25/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

// составляем колоду всех карт
struct CardDeck {
    private(set) var cards = [Card]()
    
    init() {
        for color in Card.Variant.allCases {
            for number in Card.Variant.allCases {
                for shading in Card.Variant.allCases {
                    for shape in Card.Variant.allCases {
                        cards.append(Card(color: color, shading: shading, number: number, shape: shape))
                    }
                }
            }
        }
    }
    // в этом методе мы вытаскиваем случайные карты
    mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0 ..< cards.count))
        } else {
            return nil
        }
    }
}
