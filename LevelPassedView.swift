//
//  LevelPassedView.swift
//  Autism
//
//  Created by Ethelyn Huang on 1/5/23.
//

import SwiftUI

struct LevelPassedView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black, lineWidth:3)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("lightgray")))
                .frame(maxWidth: 350, maxHeight: 200)
            VStack {
                Text("Level Passed!")
                    .foregroundColor(Color.black)
                HStack {
                    if game.currentLevel < 4 {
                        Button {
                            game.currentLevel += 1
                            game.progress = 0
                            game.remainingTime = 120
                            game.levelState = .playing
                            if game.mode == 1 {
                                game.modeAQuestion = game.chooseModeAQuestion()
                            } else if game.mode == 2 {
                                game.modeBQuestion = game.chooseModeBQuestion()
                            } else {
                                game.modeCQuestion = game.chooseModeCQuestion()
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("optionblue"))
                                    .frame(maxWidth: 140, maxHeight: 50)
                                Text("Next level")
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    
                    Button {
                        dismiss ()
                        game.progress = 0
                        game.remainingTime = 120
                        game.levelState = .playing
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("optionblue"))
                                .frame(maxWidth: 140, maxHeight: 50)
                            Text("Back to levels")
                                .foregroundColor(Color.black)
                        }
                        
                    }
                }
                }
            }
    }
}

struct LevelPassedView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        LevelPassedView()
            .environmentObject(game)
    }
}
