//
//  Question.swift
//  TrueFalseStarter
//
//  Created by thechemist on 4/19/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

class Question {
    
    let question: String
    let answer1: String
    let answer2: String
    let answer3: String
    let answer4: String
    let correctAnswer: Int
    
    init(question: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer: Int){
        self.question = question
        self.answer1 = answer1
        self.answer2 = answer2
        self.answer3 = answer3
        self.answer4 = answer4
        self.correctAnswer = correctAnswer
    }


}
