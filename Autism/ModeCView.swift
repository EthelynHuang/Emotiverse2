//
//  ModeCView.swift
//  Autism
//
//  Created by Ethelyn Huang on 24/3/23.
//

import SwiftUI

struct ModeCView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    @State var explanation: String?
    @State var answer: String?
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
            Button { //options
                withAnimation {
                    explanation = game.modeCQuestion.explanation[game.modeCSubquestionIndex]
                    answer = game.modeCQuestion.answer[game.modeCSubquestionIndex]
                    isCorrect[text] = game.processModeCQuestion(guess:text)
                    //stop the timer
                    game.timerRunning = false
                }
            } label: {
                Text(text)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.black)
                
            }
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 350, maxHeight: 50)
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
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkblue, lineWidth:8)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("lightblue")))
                    .frame(maxWidth: 350, maxHeight: 300)
    
                VStack {
                    Text(game.modeCQuestion.situation)
                        .foregroundColor(Color.black)
                        .frame(maxWidth: 320, maxHeight: 170)
                    if game.modeCQuestion.question.count >= 1 {
                        Text(game.modeCQuestion.question[game.modeCSubquestionIndex])
                            .foregroundColor(Color.black)
                            .frame(maxWidth: 320, maxHeight: 100)
                    }
                }
                .padding()
            }
            
            optionView(text: "Very appropriate")
            optionView(text: "Appropriate")
            optionView(text: "Inappropriate")
            optionView(text: "Very inappropriate")
                .padding(.bottom, 30)
    
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundTopBlue, .backgroundMiddleBlue, .backgroundLowBlue]), startPoint: .top, endPoint: .bottom)
            )
        .saturation(game.levelState != .fail ? 1 : 0.1) //if-else statement shortcut. ? = if, : = else
        .overlay {
            if let explanation, let answer {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.black, lineWidth:3)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("lightgray")))
                            .frame(maxWidth: 350, maxHeight: 200)
                        VStack {
                            Text("Correct answer: " + answer)
                                .foregroundColor(Color.black)
                            Text(explanation)
                                .foregroundColor(Color.black)
                        }
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: 330, maxHeight: 170)
                    }
                    .padding(.top, 80)
                    Spacer()
                    Text("Tap anywhere to continue")
                        .foregroundColor(Color.black)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation{
                        self.explanation = nil
                        self.answer = nil
                        game.timerRunning = true
                        isCorrect = [String: Bool?]()
                        game.modeCQuestion = game.chooseModeCQuestion()
                    }
                }
            }
            if game.levelState == .pass {
                LevelPassedView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            else if game.levelState == .fail {
                LevelFailedView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)      .contentShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .task {
            game.playCLevel()
        }
        .onReceive(game.timer) { time in
            if game.timerRunning {
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


struct ModeCView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        ModeCView()
            .environmentObject(game)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))

        ModeCView()
            .environmentObject(game)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}

extension Color {
    static var darkblue = Color("darkblue")
    static var lightblue = Color("lightblue")
    static var backgroundLowBlue = Color("backgroundLowBlue")
    static var backgroundMiddleBlue = Color("backgroundMiddleBlue")
    static var backgroundTopBlue = Color("backgroundTopBlue")
}
