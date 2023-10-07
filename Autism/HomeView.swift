//
//  HomeView.swift
//  Autism
//
//  Created by Ethelyn Huang on 2/4/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var game: Game
    @State private var isPresentedA = false
    @State private var isPresentedB = false
    @State private var isPresentedC = false
    fileprivate func optionView(text: String) -> some View {
        return ZStack {
            Button {
                if text == "Social Norms" {
                    game.mode = 1
                    isPresentedA.toggle()
                } else if text == "Emotion Recognition" {
                    game.mode = 2
                    isPresentedB.toggle()
                } else {
                    game.mode = 3
                    isPresentedC.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(lineWidth:3).foregroundColor(Color("darkred"))
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("darkred")))
                    Text(text)
                        .foregroundColor(.black)
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: 250, minHeight: 80, maxHeight: 90)
                
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .fullScreenCover(isPresented: $isPresentedA, content: LevelsView.init)
            .fullScreenCover(isPresented: $isPresentedB, content: LevelsView.init)
            .fullScreenCover(isPresented: $isPresentedC, content: LevelsView.init)
        }
        .minimumScaleFactor(0.5)
        
    }
    var body: some View {
        ZStack {
            VStack {
                Image("header3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 600)
                    .padding(20)
                    .layoutPriority(1)
                optionView(text: "Social Norms")
                    .layoutPriority(0.8)
                optionView(text: "Emotion Recognition")
                    .layoutPriority(0.8)
                optionView(text: "Cognitive Empathy")
                    .layoutPriority(0.8)
                Spacer()
            }

            Image("ghost")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 270)
                .offset(x: 100, y:250)
                .transition(.slide)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("homeblue"))
    }
}

struct HomeView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        HomeView()
            .environmentObject(game)
    }
}
