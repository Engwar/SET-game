//
//  Game.swift
//  SET game
//
//  Created by Igor Shelginskiy on 7/26/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation
struct Game {
    
    private(set) var flipCount = 0
    private(set) var score = 0
    private(set) var numberSets = 0
    
    private(set) var cardsOnTable = [Card]() //карты на игровом поле
    private(set) var cardsSelected = [Card]() // карты которые выбрали, не больше трех
    private(set) var cardsTryMatched = [Card]() //карты, выбранные для проверки Set
    private(set) var cardsRemoved = [Card]() //карты, составившие Set и удаленные из игры
    
    private var deck = CardDeck() //инкапсулируем колоду карт
    var deckCount: Int {return deck.cards.count}
    
    //проверяем выбранные карты на Set
    var isSet: Bool? {
        get {
            guard cardsTryMatched.count == 3 else {return nil}
            return Card.isSet(cards: cardsTryMatched)
        }
        set {
            if newValue != nil {
                if newValue! {          //карты совпали
                    score += Points.matchBonus //начисляются баллы за совпадение
                    numberSets += 1
                } else {               //карты не совпали
                    score -= Points.missMatchPenalty //начисляем штраф
                }
                cardsTryMatched = cardsSelected
                cardsSelected.removeAll()
            } else {
                cardsTryMatched.removeAll()
            }
        }
    }
    
    //метод берет три случайные карты из колоды, если они еще остались
    private mutating func take3FromDeck() -> [Card]?{
        var threeCards = [Card]()
        for _ in 0...2 {
            if let card = deck.draw() {
                threeCards += [card]
            } else {
                return nil
            }
        }
        return threeCards
    }
    
    //метод добавляет три случайные карты на стол
    mutating func deal3() {
        if let deal3Cards =  take3FromDeck() {
            cardsOnTable += deal3Cards
        }
    }
    
    // основной метод
    mutating func chooseCard(at index: Int) {
        assert(cardsOnTable.indices.contains(index),
               "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
        
        let cardChoosen = cardsOnTable[index]
        if !cardsRemoved.contains(cardChoosen) && !cardsTryMatched.contains(cardChoosen){
            if  isSet != nil{
                if isSet! { replaceOrRemove3Cards()}
                isSet = nil
            }
            if cardsSelected.count == 2, !cardsSelected.contains(cardChoosen){
                cardsSelected += [cardChoosen]
                isSet = Card.isSet(cards: cardsSelected)
            } else {
                cardsSelected.inOut(element: cardChoosen)
            }
            flipCount += 1
            score -= Points.flipOverPenalty
        }
    }
    
    //метод заменяет(replace) три случайные карты на новые карты из колоды, иначе удаляет их(remove) если колода пуста
    private mutating func replaceOrRemove3Cards(){
        if cardsOnTable.count == Constants.startNumberCards, let take3Cards = take3FromDeck() {
            cardsOnTable.replace(elements: cardsTryMatched, with: take3Cards)
        } else {
            cardsOnTable.remove(elements: cardsTryMatched)
        }
        cardsRemoved += cardsTryMatched
        cardsTryMatched.removeAll()
    }
    
    
    
    var hints: [[Int]] {
        var hints = [[Int]]()
        if cardsOnTable.count > 2 {
            for i in 0..<cardsOnTable.count {
                for j in (i+1)..<cardsOnTable.count {
                    for k in (j+1)..<cardsOnTable.count {
                        let cards = [cardsOnTable[i], cardsOnTable[j], cardsOnTable[k]]
                        if Card.isSet(cards: cards) {
                            hints.append([i,j,k])
                        }
                    }
                }
            }
        }
        if let itIsSet = isSet,itIsSet {
            let matchIndices = cardsOnTable.indices(of: cardsTryMatched)
            return hints.map{ Set($0)}
                .filter{$0.intersection(Set(matchIndices)).isEmpty}
                .map{Array($0)}
        }
        return hints
    }
    
    init() {
        for _ in 1...Constants.startNumberCards {
            if let card = deck.draw() {
                cardsOnTable += [card]
            }
        }
    }
    //------------------ Constants -------------
    private struct Points {
        static let matchBonus = 20
        static let missMatchPenalty = 10
        static var maxTimePenalty = 10
        static var flipOverPenalty = 1
    }
    
    private struct Constants {
        static let startNumberCards = 12
    }
}

extension Array where Element : Equatable {
    /// переключаем присутствие элемента в массиве:
    /// если нет - включаем, если есть - удаляем
    mutating func inOut(element: Element){
        if let from = self.firstIndex(of:element)  {
            self.remove(at: from)
        } else {
            self.append(element)
        }
    }
    
    mutating func remove(elements: [Element]){
        /// Удаляем массив элементов из массива
        self = self.filter { !elements.contains($0) }
    }
    
    mutating func replace(elements: [Element], with new: [Element] ){
        /// Заменяем элементы массива на новые
        guard elements.count == new.count else {return}
        for idx in 0..<new.count {
            if let indexMatched = self.index(of: elements[idx]){
                self [indexMatched ] = new[idx]
            }
        }
    }
    
    func indices(of elements: [Element]) ->[Int]{
        guard self.count >= elements.count, elements.count > 0 else {return []}
        /// Ищем индексы элементов elements у себя - self
        return elements.map{self.index(of: $0)}.compactMap{$0}
    }
}


