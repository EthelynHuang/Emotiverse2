//
//  CompletionBarView.swift
//  Autism
//
//  Created by Ethelyn Huang on 2/4/23.
//

import SwiftUI

struct CompletionBarView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment:.leading) {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.blue, lineWidth:2.5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("lightgray")))
                
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.blue, lineWidth:2.5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.yellow))
                    .frame(width: geometry.size.width * CGFloat(game.progress))
            }
        }
        .frame(height: 20)
    }
}

struct CompletionBarView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        CompletionBarView()
            .environmentObject(game)
    }
}
