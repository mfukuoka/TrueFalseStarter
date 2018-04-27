//
//  Quiz.swift
//  TrueFalseStarter
//
//  Created by thechemist on 4/19/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

class Quiz {
    
    var questions: [Question]
    
    init() {
        self.questions = getQuestionsFromDb()
    }
    
}

func getQuestionsFromDb() -> [Question]{
    
    //select * from dbo.questions :)
    var questions: [Question] = []
    
    let q1 = Question(question: "This was the only US President to serve more than two consecutive terms.", answer1: "George Washington", answer2: "Franklin D. Roosevelt", answer3: "Woodrow Wilson", answer4: "Andrew Jackson", correctAnswer: 2)
    
    let q2 = Question(question: "Which of the following countries has the most residents?", answer1: "Nigeria", answer2: "Russia", answer3: "Iran", answer4: "Vietnam", correctAnswer: 1)
    
    let q3 = Question(question: "In what year was the United Nations founded?", answer1: "1918", answer2: "1919", answer3: "1945", answer4: "1954", correctAnswer: 3)
    
    let q4 = Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", answer1: "Paris", answer2: "Washington D.C.", answer3: "New York City", answer4: "", correctAnswer: 3)
    let q5 = Question(question: "Which nation produces the most oil?", answer1: "Iran", answer2: "Iraq", answer3: "Brazil", answer4: "Canada", correctAnswer: 4)
    let q6 = Question(question: "Which country has most recently won consecutive World Cups in Soccer?", answer1: "Italy", answer2: "Brazil", answer3: "Argentina", answer4: "Spain", correctAnswer: 2)
    let q7 = Question(question: "Which of the following rivers is longest?", answer1: "Yangtze", answer2: "Mississippi", answer3: "Congo", answer4: "Mekong", correctAnswer: 2)
    let q8 = Question(question: "Which city is the oldest?", answer1: "Mexico City", answer2: "Cape Town", answer3: "San Juan", answer4: "Sydney", correctAnswer: 1)
    let q9 = Question(question: "Which country was the first to allow women to vote in national elections?", answer1: "Poland", answer2: "United States", answer3: "Sweden", answer4: "", correctAnswer: 1)
    let q10 = Question(question: "Which of these countries won the most medals in the 2012 Summer Games?", answer1: "France", answer2: "Great Britian", answer3: "Japan", answer4: "", correctAnswer: 2)
    
    questions.append(q1)
    questions.append(q2)
    questions.append(q3)
    questions.append(q4)
    questions.append(q5)
    questions.append(q6)
    questions.append(q7)
    questions.append(q8)
    questions.append(q9)
    questions.append(q10)

    
    
    return questions
}
