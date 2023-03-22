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
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]){
                ForEach(viewModel.cards){ card in
                    CardView(card: card)
                        .aspectRatio(2/3 , contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }.padding(.horizontal).foregroundColor(Color.red)
    }
}


struct CardView : View{

    let card : MemoryGameViewModel.Card
    
    var body : some View{
        GeometryReader{ geometry in
            ZStack{
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp || card.isMatched{
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder (lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                }
                else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(in size : CGSize) -> Font{
        return Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants{
        static let cornerRadius : CGFloat = 20
        static let lineWidth : CGFloat = 3
        static let fontScale : CGFloat = 0.8
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var viewModel = MemoryGameViewModel()
        ContentView(viewModel: viewModel)
    }
}
