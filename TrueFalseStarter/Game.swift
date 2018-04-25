//
//  Game.swift
//  TrueFalseStarter
//
//  Created by thechemist on 4/20/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit
import AudioToolbox



class Game {
    var quiz = Quiz()
    var correctAnswers = 0
    var totalQuestions = 0
    var questionsAsked = 0
    var numberOfRounds = 5
    var isOver = false
    var questionsAnswered = 0
    var currentQuestion: Question?
    var gameTimer: DispatchWorkItem?
    let defaultButtonColor = UIColor.init(red: 12/255.0, green: 121/255.0, blue: 150/255.0, alpha: 1)
    let correctAnswerColor = UIColor.init(red: 51/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1)
    let incorrectAnswerColor = UIColor.init(red: 0/255.0, green: 231/255.0, blue: 254/255.0, alpha: 0.2)
    let incorrectTextColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.25)
    init(){
        totalQuestions = quiz.questions.count
    }
    
    ///makes the button visible and changes background color and title color to default
    func defaultStyleFor(button: UIButton){
            button.backgroundColor = self.defaultButtonColor
            button.setTitleColor(UIColor.white, for: .normal)
            button.isHidden = false
    }
    ///changes the style to that of an answer button
    func correctAnswerStyleFor(button: UIButton){
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = correctAnswerColor
        
    }
    //dims the buttons to better highlight the answer button
    func incorrectAnswerStyleFor(button: UIButton){
        button.backgroundColor = incorrectAnswerColor
        button.setTitleColor(incorrectTextColor, for: .normal)
    }
    
    ///changes the current question to a random one from the list
    func startRound(){
        currentQuestion = self.pickRandomQuestion()
    }
    
    ///starts the game over
    func restartGame(){
        self.playGameStartSound()
        quiz = Quiz()
        correctAnswers = 0
        totalQuestions = quiz.questions.count
        questionsAsked = 0
        questionsAnswered = 0
    }
    
    ///remove a random question from the quiz
    func pickRandomQuestion() -> Question? {
        questionsAsked += 1 
        if quiz.questions.count > 0 {
        
        return quiz.questions.remove(at: GKRandomSource.sharedRandom().nextInt(upperBound: quiz.questions.count))
        }
        else{
            return nil
        }
    }
    //function to get the current questions correct answer
    func isAnswerCorrect(question: Question?, answer: Int) -> (isCorrect: Bool,answer: Int){
        if let correctAnswer = question?.correctAnswer {
            questionsAnswered += 1
            if questionsAnswered == numberOfRounds ||
                questionsAsked == totalQuestions {
                isOver=true
            }
            if correctAnswer == answer {
                self.correctAnswers += 1
                self.playCorrectAnswerSound()
                return (isCorrect: true, answer: correctAnswer)
            }
            else{
                 self.playWrongAnswerSound()
                return (isCorrect: false, answer: correctAnswer)
                
            }
        }
        else {
            return (isCorrect: false, answer: 0)
        }
    }
    
    //sounds for the game
    var gameSound: SystemSoundID = 0
    func loadGameStartSound() {
        
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        self.loadGameStartSound()
        AudioServicesPlaySystemSound(gameSound)
    }
    func playCorrectAnswerSound(){
        AudioServicesPlaySystemSound(1016)
    }
    func playWrongAnswerSound(){
        AudioServicesPlaySystemSound(1006)
    }
    func playGameEndSound(){
    AudioServicesPlaySystemSound(1027)
    }
}

