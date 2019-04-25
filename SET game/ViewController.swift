//
//  ViewController.swift
//  SET game
//
//  Created by Igor Shelginskiy on 4/24/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardButtons: [BorderButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton()
    }
    
    private func updateButton() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < 12 {
                button.setTitle(" ", for: .normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            }
        }
    }


}

