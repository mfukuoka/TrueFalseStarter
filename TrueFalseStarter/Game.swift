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

var gameSound: SystemSoundID = 0
class Game {
    var quiz = Quiz()
    var correctAnswers = 0
    var totalQuestions = 0
    init(){
        
        totalQuestions = quiz.questions.count
    }
    func restartGame(){
        self.playGameStartSound()
        quiz = Quiz()
        correctAnswers = 0
        totalQuestions = quiz.questions.count
    }
    func pickRandomQuestion() -> Question? {
        if quiz.questions.count > 0 {
        return quiz.questions.remove(at: GKRandomSource.sharedRandom().nextInt(upperBound: quiz.questions.count))
        }
        else{
            return nil
        }
    }
    
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

