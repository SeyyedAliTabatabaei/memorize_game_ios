//
//  MemoryGame.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/18/23.
//
// MODEL


import Foundation

struct MemoryGameModel<CardContent> where CardContent : Equatable {
    
    private(set) var cards : Array<Card>
    private var indexOfOneAndOnlyFaceUpCard : Int? {
        get{  cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach({cards[$0].isFaceUp = ($0 == newValue)}) }
    }
    
    mutating func choose(_ card : Card){
        if let index = cards.firstIndex(where: {$0.id == card.id}) , !cards[index].isFaceUp , !cards[index].isMatched  {
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard{
                if cards[index].content == cards[potentialMatchIndex].content{
                    cards[index].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[index].isFaceUp = true
            }else {
                
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCard : Int , createCardContent : (Int) -> CardContent){
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCard {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content , id: pairIndex*2))
            cards.append(Card(content: content , id: pairIndex*2+1))
            
        }
    }
    
    
    struct Card : Identifiable{
        var isFaceUp = false
        var isMatched = false
        var content : CardContent
        var id: Int
    }
}

extension Array{
    var oneAndOnly : Element? {
        if count == 1 {
            return first
        }else {
            return nil
        }
    }
}
