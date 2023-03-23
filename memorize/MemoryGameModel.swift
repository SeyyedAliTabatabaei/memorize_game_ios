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
    
    mutating func shuffle(){
        cards.indices.forEach({ cards[$0].isFaceUp = false})
        cards.shuffle()
    }
    
    init(numberOfPairsOfCard : Int , createCardContent : (Int) -> CardContent){
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCard {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content , id: pairIndex*2))
            cards.append(Card(content: content , id: pairIndex*2+1))
            
        }
        cards.shuffle()
    }
    
    
    struct Card : Identifiable{
        var isFaceUp = false {
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet{
                stopUsingBonusTime()
            }
        }
        var content : CardContent
        var id: Int
        
        
        
        
    
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date() .timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit: 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime () {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date ()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
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




