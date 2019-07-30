//
//  CardButton.swift
//  SET game
//
//  Created by Igor Shelginskiy on 7/30/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

//создаем класс для кнопки SET с наследованием от BorderButton чтобы определить цвет границы в зависимости от обстоятельств
@IBDesignable class SetCardButton: BorderButton {
    //четыре массива для отображения характеристик карты
    var colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)]
    var alphas:[CGFloat] = [1.0, 0.40, 0.15] //значение непрозначности для трех вариантов затенения фигур
    var strokeWidths:[CGFloat] = [ -8, 8, -8]
    var symbols = ["●", "▲", "■"]
    
    var setCard: Card? = Card( color: Card.Variant.v3,
                               shading: Card.Variant.v3,
                               number: Card.Variant.v3,
                               shape: Card.Variant.v3) { didSet{updateButton()}}
    
    //функция устанавливает атрибуты кнопки и выводит результат
    private func setAttributedString(card: Card) -> NSAttributedString{
        let symbol = symbols[card.shape.idx]
        let separator = verticalSizeClass == .regular ? "\n" : " "    //создаем расположение символов в зависимости от положения экрана
        let symbolsString = symbol.join(n: card.number.rawValue, with: separator) //формируем строку символов
        let attributes:[NSAttributedString.Key : Any] = [                        //наделяем карту артибутами
            .strokeColor: colors[card.color.idx],                                //цвет контура
            .strokeWidth: strokeWidths[card.shading.idx],                        //ширина обводки символа
            .foregroundColor: colors[card.color.idx].withAlphaComponent(alphas[card.shading.idx]) //цвет и прозрачность символов
        ]
        return NSAttributedString(string: symbolsString, attributes: attributes)
    }
    
    //настраиваем внешний вид кнопки
    private func updateButton () {
        if let card = setCard { //если карта установлена то
            let attributedString  = setAttributedString(card: card) //создаем заголовок кнопки
            setAttributedTitle(attributedString, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            isEnabled = true //взаимодействуем с кнопкой, делаем ее доступной
        } else {
            setAttributedTitle(nil, for: .normal)  // иначе прозрачная недоступная кнопка
            setTitle(nil, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            colorBorder =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            isEnabled = false
        }
    }
    var verticalSizeClass: UIUserInterfaceSizeClass {return  // определяем режим (ландшафт или портрет)
        UIScreen.main.traitCollection.verticalSizeClass}
    
    func setBorderColor (color: UIColor) { //определяем цвет и ширину границы кнопки для индикации выбранной карты
        colorBorder =  color
        widthBorder = Constants.widthBorder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateButton()                      //обновляем кнопку: изменились ли границы при повороте экрана для отображения символов
    }
    
    private func configure () {
        radiusCorner = Constants.cornerRadius
        titleLabel?.numberOfLines = 0
        colorBorder = Constants.colorBorder
        widthBorder = -Constants.widthBorder
    }
    
    //-------------------Constants--------------
    private struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let widthBorder: CGFloat = 5.0
        static let colorBorder: UIColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}

extension String {
    func join(n: Int, with separator:String )-> String{ //расширение для формирования строки, где n - количество символов
        guard n > 1 else {return self}
        var symbols = [String] ()
        for _ in 0..<n {
            symbols += [self]
        }
        return symbols.joined(separator: separator)
    }
}
