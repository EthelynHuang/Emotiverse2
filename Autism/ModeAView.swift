//
//  ModeAView.swift
//  Autism
//
//  Created by Ethelyn Huang on 2/4/23.
//

import SwiftUI

struct ModeAView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    @State var isCorrect = [String: Bool?]()
    fileprivate func optionView(text: String) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black, lineWidth:1)
                .background(
                    RoundedRectangle(cornerRadius: 10).foregroundColor(
                        isCorrect[text] == nil ? Color("lightgray") : (
                            isCorrect[text] == true ? .green : .red
                        )
                    )
                )
            Button {
                Task {
                    withAnimation { isCorrect[text] = game.processModeAQuestion(guess:text) }
                    game.timerRunning = false
                    try! await Task.sleep(nanoseconds: 800_000_000)
                    game.timerRunning = true
                    isCorrect = [String: Bool?]()
                    game.modeAQuestion = game.chooseModeAQuestion()
                }
            } label: {
                Text(text)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.black)
                
            }
                .contentShape(RoundedRectangle(cornerRadius: 10))
//                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 350)
        .minimumScaleFactor(0.5)
        
    }
    
    var body: some View {
        VStack (spacing:20) {
            HStack {
                Button {
                    dismiss()
                    game.progress = 0
                } label: {
                    Image("backButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 40)
                }
                CompletionBarView()
                Text("\(game.remainingTime)")
                    .frame(maxWidth: 50, maxHeight: 30)
                    .foregroundColor(Color.black)
                
            }
            VStack(spacing: 20) {
                Text(game.modeAQuestion.prompt)
                    .foregroundColor(Color(.black))
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.title)
                    .layoutPriority(1)
                

                if game.modeAQuestion.options.count >= 1 {
                    optionView(text: game.modeAQuestion.options[0])
                }
                if game.modeAQuestion.options.count >= 2 {
                    optionView(text: game.modeAQuestion.options[1])
                }
                if game.modeAQuestion.options.count >= 3 {
                    optionView(text: game.modeAQuestion.options[2])
                }
                
            }
            
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundTopBlue, .backgroundMiddleBlue, .backgroundLowBlue]), startPoint: .top, endPoint: .bottom)
            )
        .saturation(game.levelState != .fail ? 1 : 0.1) //if-else statement shortcut. ? = if, : = else
        .overlay {
            if game.levelState == .pass {
                LevelPassedView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            else if game.levelState == .fail {
                LevelFailedView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
        }
        .task {
            game.playALevel()
        }
        .onReceive(game.timer) { time in
            if game.timerRunning && game.levelState == .playing {
                if game.remainingTime > 0 {
                    game.remainingTime -= 1
                }
                else {
                    game.levelState = .fail
                }
            }
        }
    }
}
    
struct ModeAView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        ModeAView()
            .environmentObject(game)
    }

}

