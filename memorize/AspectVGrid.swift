//
//  AspectVGrid.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/22/23.
//

import SwiftUI

struct AspectVGrid<Item , ItemView>: View where ItemView : View  , Item : Identifiable{
    
    var items : [Item]
    var aspectRatio : CGFloat
    var content : (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat,@ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                let width : CGFloat = widthThatfits(itemCount: items.count, in: geometry.size, itemspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width : width)] , spacing: 0 ) {
                    ForEach(items){item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
            Spacer(minLength: 0)
            
        }
        
    }
    
    func adaptiveGridItem(width : CGFloat) -> GridItem{
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatfits(itemCount: Int, in size: CGSize, itemspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemwidth = size.width / CGFloat (columnCount)
            let itemHeight = itemwidth / itemspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor (size.width / CGFloat (columnCount))
    }
    
    
}

