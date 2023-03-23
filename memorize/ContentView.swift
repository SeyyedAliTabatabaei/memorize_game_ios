//
//  ContentView.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/17/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel : MemoryGameViewModel
    @Namespace private var dealingNameSpace
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                gameBody
                HStack{
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            .padding()
            deckBody
        }
    }
    
    @State private var dealt = Set<Int>()
    private func deal(_ card : MemoryGameViewModel.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card : MemoryGameViewModel.Card) -> Bool{
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card : MemoryGameViewModel.Card) -> Animation{
        var delay = 0.0
        if let index = viewModel.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration / Double(viewModel.cards.count))
        }
        
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card : MemoryGameViewModel.Card) -> Double{
        -Double(viewModel.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody : some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3, content: { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp{
                Color.clear
            }else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of : card))
                    .onTapGesture {
                        withAnimation{
                            viewModel.choose(card)
                        }
                    }
            }
        })
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody : some View{
        ZStack{
            ForEach(viewModel.cards.filter(isUndealt)){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of : card))

            }
        }
        .frame(width: CardConstants.undealtwidth , height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in viewModel.cards{
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    var shuffle : some View {
        Button("Shuffle"){
            withAnimation{
                viewModel.shuffle()
            }
        }
    }
    
    var restart : some View {
        Button("Restart"){
            withAnimation{
                dealt = []
                viewModel.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtwidth = undealtHeight * aspectRatio
    }
}


struct CardView : View{

    let card : MemoryGameViewModel.Card
    
    @State private var animatedBonusRemaining : Double = 0
    
    var body : some View{
        GeometryReader{ geometry in
            ZStack{
                Group{
                    if card.isConsumingBonusTime{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear{
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaining = 0
                                }
                            }
                    }else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5).opacity(0.5)

                
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false) , value: card.isMatched)
                    .font(font(in: geometry.size))                    
            }
            .cardify(faceUp: card.isFaceUp, matched: card.isMatched)
        }
    }
    
    private func font(in size : CGSize) -> Font{
        return Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants{
        static let cornerRadius : CGFloat = 20
        static let lineWidth : CGFloat = 3
        static let fontScale : CGFloat = 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var viewModel = MemoryGameViewModel()
        ContentView(viewModel: viewModel)
    }
}
