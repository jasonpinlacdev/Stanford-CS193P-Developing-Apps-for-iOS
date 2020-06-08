//
//  ConcentrationVC.swift
//  Concentration
//
//  Created by Jason Pinlac on 6/7/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

enum GameState {
    case noCardsTouched
    case oneCardTouched
    case twoCardsTouched
}


class ConcentrationVC: UIViewController {
    
    let tapsLabel = UILabel()
    
    var cards = [CardButton]()
    var verticalStackView: UIStackView?
    
    var gameState: GameState = .noCardsTouched
    var firstCardTouched: CardButton?
    var secondCardTouched: CardButton?
    var numberOfCardsFlipped = 0 {
        didSet {
            tapsLabel.text = "Cards Flipped: \(numberOfCardsFlipped)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTapsLabel()
        setupCards()
        configureStackViews()
    }
    
    
    @objc func touchCard(_ sender: CardButton) {
        guard !(gameState == .twoCardsTouched) else {
            gameState = .noCardsTouched
            flipAllNonMatchedCardsDown()
            firstCardTouched = nil
            secondCardTouched = nil
            return
        }
        guard sender != firstCardTouched else { return }
        guard !sender.isMatched else { return }
        
        numberOfCardsFlipped += 1
        
        switch gameState {
        case .noCardsTouched:
            gameState = .oneCardTouched
            flip(card: sender)
            firstCardTouched = sender
            
        case .oneCardTouched:
            gameState = .twoCardsTouched
            flip(card: sender)
            secondCardTouched = sender
            
            if firstCardTouched?.titleLabel?.text == secondCardTouched?.titleLabel?.text {
                gameState = .noCardsTouched
                firstCardTouched?.isMatched = true
                secondCardTouched?.isMatched = true
                firstCardTouched = nil
                secondCardTouched = nil
                checkIfGameIsOver()
            }
        case .twoCardsTouched:
            break
        }
    }
    
    
    
    
    
    // MARK: - Private Section -
    
    
    private func flip(card: CardButton) {
        if !card.isFlippedUp {
            card.flipUp()
        } else {
            card.flipDown()
        }
    }
    
    
    private func flipAllNonMatchedCardsDown() {
        for card in cards {
            if card.isFlippedUp && !card.isMatched {
                card.flipDown()
            }
        }
    }
    
    
    private func checkIfGameIsOver() {
        for card in cards {
            if !card.isMatched { return }
        }
        let alertController = UIAlertController(title: "Congratulations!", message: "Would you like to restart?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Restart", style: .default){ _ in
            self.restartGame()
        })
        present(alertController, animated: true)
    }
    
    
    private func restartGame() {
        guard let verticalStackView = verticalStackView else { return }
        for horizontalStackView in verticalStackView.arrangedSubviews {
            if let horizontalStackView = horizontalStackView as? UIStackView {
                for card in horizontalStackView.arrangedSubviews {
                    if let card = card as? CardButton {
                        horizontalStackView.removeArrangedSubview(card)
                    }
                }
                verticalStackView.removeArrangedSubview(horizontalStackView)
            }
        }
        verticalStackView.removeFromSuperview()
        self.verticalStackView = nil
        cards.removeAll(keepingCapacity: true)
        setupCards()
        configureStackViews()
        numberOfCardsFlipped = 0
    }
    
    
    private func configure() {
        title = "Concentration Game"
        view.backgroundColor = UIColor.systemBackground
    }
    
    
    private func configureTapsLabel() {
        tapsLabel.text = "Cards Flipped: \(numberOfCardsFlipped)"
        tapsLabel.textAlignment = .center
        tapsLabel.font = UIFont.systemFont(ofSize: 24)
        tapsLabel.adjustsFontSizeToFitWidth = true
        tapsLabel.minimumScaleFactor = 0.5
        
        view.addSubview(tapsLabel)
        tapsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tapsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tapsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tapsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tapsLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
    }
    
    
    private func setupCards() {
        var arrayOfSymbols = EmojiSymbols.allCases
        arrayOfSymbols.shuffle()
        
        for index in 0 ..< 10{
            let cardA = CardButton(symbol: arrayOfSymbols[index].rawValue)
            let cardB = CardButton(symbol: arrayOfSymbols[index].rawValue)
            
            cardA.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
            cardB.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
            
            cards.append(contentsOf: [cardA, cardB])
        }
        cards.shuffle()
    }
    
    
    private func configureStackViews() {
        verticalStackView = UIStackView()
        guard let verticalStackView = verticalStackView else { return }
        
        view.addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 5.0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: tapsLabel.bottomAnchor, constant: 5),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        var horizontalStackView = UIStackView()
        for (index, card) in cards.enumerated() {
            if index % 4 == 0 {
                horizontalStackView = UIStackView()
                horizontalStackView.axis = .horizontal
                horizontalStackView.distribution = .fillEqually
                horizontalStackView.spacing = 5.0
                verticalStackView.addArrangedSubview(horizontalStackView)
                
            }
            horizontalStackView.addArrangedSubview(card)
        }
    }
    
}
