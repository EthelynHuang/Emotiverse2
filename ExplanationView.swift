//
//  ExplanationView.swift
//  Autism
//
//  Created by Ethelyn Huang on 16/8/23.
//

import SwiftUI

struct ExplanationView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    var explanation: String
    var answer: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black, lineWidth:3)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("lightgray")))
                .frame(maxWidth: 350, maxHeight: 200)
            VStack {
                Text("Correct answer: " + answer)
                    .foregroundColor(Color(.black))
                Text(explanation)
                    .foregroundColor(Color(.black))
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: 330, maxHeight: 170)
            }
        }
    }
}

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView(explanation: "", answer: "")
    }
}
