//
//  Cardify.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/23/23.
//

import SwiftUI


struct Cardify : ViewModifier{
    
    var isFaceUp : Bool
    var isMatched : Bool
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isFaceUp || isMatched{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder (lineWidth: DrawingConstants.lineWidth)
            }
            else {
                shape.fill().transition(AnyTransition.opacity.animation(.linear(duration: 5)))
            }
            
            content.opacity(isFaceUp ? 1 : 0)
        }
    }
    
    private struct DrawingConstants{
        static let cornerRadius : CGFloat = 20
        static let lineWidth : CGFloat = 3
    }
}


extension View{
    func cardify(faceUp : Bool , matched : Bool) -> some View{
        self.modifier(Cardify(isFaceUp: faceUp, isMatched: matched))
    }
}
