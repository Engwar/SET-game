//
//  Card.swift
//  SET game
//
//  Created by Igor Shelginskiy on 4/24/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation


struct Card: Equatable {
    //Необходимо уйти от привязки к именам цветов и фигур , чтобы сделать нашу модель UI независимой
    var color: Variant    //цвет 1, 2, 3 - green, purple, red
    var shading: Variant  // затенение 1, 2, 3 - striped, open, solid
    var number: Variant   // кол-во фигур
    var shape: Variant    // форма фигур 1, 2, 3 - oval, diamond, squiggle
    
    enum Variant: Int, CaseIterable {
        case v1 = 1, v2, v3
        var idx: Int {return (self.rawValue - 1)} //переменная для определения символа в массиве символов
    }
    
    // в  этом методе мы проверяем составляют ли три карты СЕТ или нет, если значения всех параметров одинаковы то суммы будут 3 или 6 или 9, если все разные то сумма будет 6, и то и то условие подходит чтобы объявить набор из трех карт составленным и мы проверяем это условие на деление без остатка на 3
    static func isSet(cards:[Card]) -> Bool {
        guard cards.count == 3 else {return false}
        let sum = [
            cards.reduce(0, {$0 + $1.color.rawValue}),
            cards.reduce(0, {$0 + $1.number.rawValue}),
            cards.reduce(0, {$0 + $1.shading.rawValue}),
            cards.reduce(0, {$0 + $1.shape.rawValue})
        ]
        return sum.reduce(true, {$0 && ($1 % 3 == 0)})
    }
}


