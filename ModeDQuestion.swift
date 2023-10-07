//
//  ModeCQuestion.swift
//  Autism
//
//  Created by Ethelyn Huang on 24/3/23.
//

import Foundation

struct ModeDQuestion{
    let story: String
    let totalOptions: [String] = ["amused", "annoyed", "confused", "disappointed", "excited", "nervous", "panicked", "pained", "sad", "proud", "guilty", "relieved", "touched"]
    let answer: String
    var priority: Int = 21
}
