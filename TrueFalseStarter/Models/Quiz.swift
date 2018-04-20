//
//  Quiz.swift
//  TrueFalseStarter
//
//  Created by thechemist on 4/19/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

class Quiz {
    
    let questions: [Question]
    
    init() {
        self.questions = getQuestionsFromDb()
    }
    
}

func getQuestionsFromDb() -> [Question]{
    
    //select * from dbo.questions :)
    var questions: [Question] = []
    
    let q1 = Question(question: "This was the only US President to serve more than two consecutive terms.", option1: "George Washington", option2: "Franklin D. Roosevelt", option3: "Woodrow Wilson", option4: "Andrew Jackson", correctAnswer: 2)
    
    let q2 = Question(question: "Which of the following countries has the most residents?", option1: "Nigeria", option2: "Russia", option3: "Iran", option4: "Vietnam", correctAnswer: 1)
    
    let q3 = Question(question: "In what year was the United Nations founded?", option1: "1918", option2: "1919", option3: "1945", option4: "1954", correctAnswer: 3)
    
    questions.append(q1)
    questions.append(q2)
    questions.append(q3)
    
    return questions
}
