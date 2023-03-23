//
//  ContentView.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/17/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel : MemoryGameViewModel
    
    var body: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3, content: { card in
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        })
        .padding(.horizontal).foregroundColor(Color.red)
    }
}


struct CardView : View{

    let card : MemoryGameViewModel.Card
    
    var body : some View{
        GeometryReader{ geometry in
            ZStack{
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 180-90)).padding(5).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(.easeOut(duration: 3) , value: card.isMatched)
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
