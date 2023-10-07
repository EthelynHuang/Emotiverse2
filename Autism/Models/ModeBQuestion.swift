//
//  ModeBQuestion.swift
//  Autism
//
//  Created by Ethelyn Huang on 19/3/23.
//

import Foundation

struct ModeBQuestion{
    let image: String
    let prompt: String = "Which emotion is best conveyed by the following picture?"
    let options: [String] = ["Sadness", "Shame", "Politeness", "Pain", "Fear", "Happiness", "Anger", "Disgust", "Surprise", "Compassion", "Amusement", "Interest"]
    let answer: String
    let explanation: String
    var priority: Int = 21
    
    func createRandomOptions() -> [String] {
        var questionOptions: [String] = []
        questionOptions.append(answer)
        while questionOptions.count < 4 {
            let x = options.randomElement() //changed from 'var' x
            if questionOptions.contains(x!) == false {
                questionOptions.append(x!)
            }
        }
        
        return questionOptions.shuffled()
    }
    
}
