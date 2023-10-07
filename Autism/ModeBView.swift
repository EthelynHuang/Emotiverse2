//
//  ContentView.swift
//  Autism
//
//  Created by Ethelyn Huang on 19/3/23.
//

import SwiftUI

struct ModeBView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    @State private var isPresented = false
    @State var explanation: String?
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
                withAnimation {
                    explanation = game.modeBQuestion.explanation
                    isCorrect[text] = game.processModeBQuestion(guess:text)
                    //stop the timer
                    game.timerRunning = false
                }
            } label: {
                Text(text)
                    .font(.system(size:14))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.black)
            }
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 360, maxHeight: 60)
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
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
            Text(game.modeBQuestion.prompt)
                .foregroundColor(Color(.black))
                .frame(maxWidth: 350, maxHeight: 120)
                .multilineTextAlignment(.center)
                .font(.title)

            Image(game.modeBQuestion.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 200)
                .clipped()
                .cornerRadius(20)
                .padding(.horizontal, 20)
            
            HStack(alignment: .center, spacing: 20) {
                VStack(spacing: 10) {
                    ForEach(game.modeBQuestionOptions, id: \.self) { option in
                        optionView(text: option)
                    }
                    .id(UUID())
                }
                .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundTopBlue, .backgroundMiddleBlue, .backgroundLowBlue]), startPoint: .top, endPoint: .bottom)
            )
        .saturation(game.levelState != .fail ? 1 : 0.1) //if-else statement shortcut. ? = if, : = else
        .task {
            game.playBLevel()
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
        .overlay {
            if let explanation {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.black, lineWidth:3)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("lightgray")))
                            .frame(maxWidth: 350, maxHeight: 150)
                        Text(explanation)
                            .foregroundColor(Color(.black))
                            .frame(maxWidth: 300, maxHeight: 130)
                    }
                    .padding(.top, 60)
                    Spacer()
                    Text("Tap anywhere to continue")
                        .foregroundColor(Color(.black))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation{
                        self.explanation = nil
                        game.timerRunning = true
                        isCorrect = [String: Bool?]()
                        game.modeBQuestion = game.chooseModeBQuestion()
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
        }
        

            
    }
    
    
}

struct ModeBView_Previews: PreviewProvider {
    @StateObject private static var game = Game()
    static var previews: some View {
        ModeBView()
            .environmentObject(game)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))

        ModeBView()
            .environmentObject(game)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}

//disgust, fear, happiness, pain, sadness, surprise
