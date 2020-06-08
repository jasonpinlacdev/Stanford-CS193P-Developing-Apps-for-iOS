//
//  CardButton.swift
//  Concentration
//
//  Created by Jason Pinlac on 6/7/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    
    var symbol: String!
    var isFlippedUp = false
    var isMatched = false
    
    
    init(symbol: String) {
        self.symbol = symbol
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func flipUp() {
        isFlippedUp = true
        setTitle(symbol, for: .normal)
        backgroundColor = .systemOrange
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    
    func flipDown() {
        isFlippedUp = false
        setTitle("", for: .normal)
        backgroundColor = .lightGray
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    
    private func configure() {
        backgroundColor     = UIColor.lightGray
        layer.cornerRadius  = 5
        clipsToBounds       = true
        titleLabel?.font = UIFont.systemFont(ofSize: 72)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    
}
