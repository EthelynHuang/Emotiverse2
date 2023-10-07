//
//  ModeALevels.swift
//  Autism
//
//  Created by Ethelyn Huang on 7/4/23.
//

import SwiftUI

struct LevelsView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    @State private var isPresented = false
    fileprivate func optionView(text: String, isDisabled: Bool) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("optionblue"))
            Button {
                if text == "Level 1" {
                    game.currentLevel = 1
                } else if text == "Level 2" {
                    game.currentLevel = 2
                } else if text == "Level 3" {
                    game.currentLevel = 3
                } else {
                    game.currentLevel = 4
                }
                game.remainingTime = 120
                isPresented.toggle()
            } label: {
                Text(text)
                    .foregroundColor(isDisabled ? Color("darkgray") : .black)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .disabled(isDisabled)
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .lineLimit(2)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 250, maxHeight: 100)
        .minimumScaleFactor(0.5)
    }
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color("backgroundTopBlue"))
                    .frame(maxWidth: 350, maxHeight: 70)
                    .minimumScaleFactor(0.5)
                HStack(spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Image("backButton2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 60)
                            .padding()
                    }
                    .padding(.leading, 10)
                    if game.mode == 1 {
                        Text("Social Norms")
                            .foregroundColor(Color(.black))
                    } else if game.mode == 2 {
                        Text("Emotion Recognition")
                            .foregroundColor(Color(.black))
                            .frame(maxHeight: 80)
                    } else {
                        Text("Cognitive Empathy")
                            .foregroundColor(Color(.black))
                            .frame(maxHeight: 80)
                    }
                    Spacer()
                }

            }
            .padding(0)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("homeblue")) 
                    .frame(maxWidth: 350, maxHeight: 540)
                    .minimumScaleFactor(0.5)
                VStack {
                    optionView(text: "Level 1", isDisabled:  game.isDisabled(level: 1))
                    optionView(text: "Level 2", isDisabled:  game.isDisabled(level: 2))
                    optionView(text: "Level 3", isDisabled:  game.isDisabled(level: 3))
                    optionView(text: "Level 4", isDisabled:  game.isDisabled(level: 4))
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            Image("vamoose2")
                .resizable()
                .ignoresSafeArea()
//                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 240, maxHeight: 200, alignment: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)        .background(Color("homeblue"))
        .fullScreenCover(isPresented: $isPresented) {
            if game.mode == 1 {
                ModeAView()
            } else if game.mode == 2 {
                ModeBView()
            } else {
                ModeCView()
            }
        }
    }
    
}

struct LevelsView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        LevelsView()
            .environmentObject(game)
    }
}
