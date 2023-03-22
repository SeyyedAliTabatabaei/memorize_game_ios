//
//  EmojiMemoryGame.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/18/23.
//
// VIEW MODEL

import SwiftUI



class MemoryGameViewModel : ObservableObject{
    
    typealias Card = MemoryGameModel<String>.Card
    
    private static let emojis  = ["🚗" ,"🚕" ,"🚙" ,"🚌" ,"🚎" ,"🏎️" ,"🚓" ,"🚑" ,"🚒" ,"🚐" ,"🛻" ,"🚚" ,"🚛" ,"🚜" ,"🚲" ,"🛵" ,"🏍️" ,"✈️" ,"🚂" ,"🚝" ,"🚀" ,"🛸" ,"🛴" ,"🚔" ,]

    
    private static func createMemoryGame() -> MemoryGameModel<String> {
        MemoryGameModel(numberOfPairsOfCard: 4 ) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    
    @Published private var model = createMemoryGame()
    
    var cards : Array<Card>{
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card : Card){
        objectWillChange.send()
        model.choose(card)
    }
    
}
