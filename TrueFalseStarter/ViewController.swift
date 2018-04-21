//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    let game = Game()
    var currentQuestion: Question?
    var gameTimer: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start game
        game.playGameStartSound()
        playAgainButton.isHidden = true
        answerLabel.isHidden = true
        currentQuestion = game.pickRandomQuestion()
        displayQuestion(question: currentQuestion!) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //resets all the answer buttons to their default state
    func setScreenToDefault(){
        let defaultColor = UIColor.init(red: 12/255.0, green: 121/255.0, blue: 150/255.0, alpha: 1)
        option1Button.backgroundColor = defaultColor
        option2Button.backgroundColor = defaultColor
        option3Button.backgroundColor = defaultColor
        option4Button.backgroundColor = defaultColor
        option1Button.setTitleColor(UIColor.white, for: .normal)
        option2Button.setTitleColor(UIColor.white, for: .normal)
        option3Button.setTitleColor(UIColor.white, for: .normal)
        option4Button.setTitleColor(UIColor.white, for: .normal)
        self.option1Button.isHidden = false
        self.option2Button.isHidden = false
        self.option3Button.isHidden = false
        self.option4Button.isHidden = false
        self.answerLabel.isHidden = true
        self.questionField.isHidden = false
    }
    func setScreenOutOfTime(){
        self.answerLabel.isHidden = false
        self.answerLabel.textColor = UIColor.init(red: 204/255.0, green: 0, blue: 0, alpha: 0.8)
        self.answerLabel.text = "You ran out of time!"
        self.questionField.isHidden = true
        self.option1Button.isHidden = true
        self.option2Button.isHidden = true
        self.option3Button.isHidden = true
        self.option4Button.isHidden = true
    }
    
    func setScreenFor(answer: Int){
        
        //highlight answer button of correct answer
        let correctAnswerColor = UIColor.init(red: 51/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1)
        let otherAnswerColor = UIColor.init(red: 0/255.0, green: 231/255.0, blue: 254/255.0, alpha: 0.2)
        let otherAnswerTextColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.25)
        switch answer {
        case 1:
            option1Button.setTitleColor(UIColor.black, for: .normal)
            option1Button.backgroundColor = correctAnswerColor
            option2Button.backgroundColor = otherAnswerColor
            option2Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option3Button.backgroundColor = otherAnswerColor
            option3Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option4Button.backgroundColor = otherAnswerColor
            option4Button.setTitleColor(otherAnswerTextColor, for: .normal)
        case 2:
            option2Button.setTitleColor(UIColor.black, for: .normal)
            option1Button.backgroundColor = otherAnswerColor
            option1Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option2Button.backgroundColor = correctAnswerColor
            option3Button.backgroundColor = otherAnswerColor
            option3Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option4Button.backgroundColor = otherAnswerColor
            option4Button.setTitleColor(otherAnswerTextColor, for: .normal)
        case 3:
            option3Button.setTitleColor(UIColor.black, for: .normal)
            option1Button.backgroundColor = otherAnswerColor
            option1Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option2Button.backgroundColor = otherAnswerColor
            option2Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option3Button.backgroundColor = correctAnswerColor
            option4Button.backgroundColor = otherAnswerColor
            option4Button.setTitleColor(otherAnswerTextColor, for: .normal)

        case 4:
            option4Button.setTitleColor(UIColor.black, for: .normal)
            option1Button.backgroundColor = otherAnswerColor
            option1Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option2Button.backgroundColor = otherAnswerColor
            option2Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option3Button.backgroundColor = otherAnswerColor
            option3Button.setTitleColor(otherAnswerTextColor, for: .normal)
            option4Button.backgroundColor = correctAnswerColor
        default:
            self.setScreenToDefault()
        }
    }
    
    //update the question label and the answer buttons
    func displayQuestion(question: Question) {
        
        //update screen
        //self.setScreenToDefault()
        currentQuestion = question
        questionField.text = question.question
        option1Button.setTitle(question.option1, for: .normal)
        option2Button.setTitle(question.option2, for: .normal)
        option3Button.setTitle(question.option3, for: .normal)
        option4Button.setTitle(question.option4, for: .normal)
        gameTimer = self.lightingMode()
    }
    
    //Show the final score, hide the answer buttons, show the play again button
    func displayScore() {
        // Hide the answer buttons
        option1Button.isHidden = true
        option2Button.isHidden = true
        option3Button.isHidden = true
        option4Button.isHidden = true
        answerLabel.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        game.playGameEndSound()
        questionField.text = "Way to go!\nYou got \(game.correctAnswers) out of \(game.totalQuestions) correct!"
        
    }
    

    
    //answer button touch up inside event
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        //show results
        answerLabel.isHidden = false
        
        //get the selected answer
        var selectedAnswer = 0
        switch sender {
        case option1Button:
            selectedAnswer = 1
        case option2Button:
            selectedAnswer = 2
        case option3Button:
            selectedAnswer = 3
        case option4Button:
            selectedAnswer = 4
        default: selectedAnswer = 0
            
        }
        
        //is answer correct?
        let correctAnswer = game.isAnswerCorrect(question: currentQuestion, answer: selectedAnswer)
        if correctAnswer.isCorrect {
            answerLabel.text = "Correct!"
            answerLabel.textColor = UIColor.init(red: 0, green: 204/255.0, blue: 0, alpha: 1)

        }
        else{
            answerLabel.text = "Wrong!"
            answerLabel.textColor = UIColor.init(red: 204/255.0, green: 0, blue: 0, alpha: 0.8)
            game.playWrongAnswerSound()
        }

        //update screen for answer results
        setScreenFor(answer: correctAnswer.answer)
        
        //cancel lighting mode since something was picked
        if let timer = gameTimer  {
            timer.cancel()
        }
        
        //load next question
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if let nextQuestion = self.game.pickRandomQuestion() {
            self.displayQuestion(question: nextQuestion)
        }
        else{
            displayScore()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        option1Button.isHidden = false
        option2Button.isHidden = false
        option3Button.isHidden = false
        option4Button.isHidden = false
        playAgainButton.isHidden = true

        //restart game
        game.restartGame()
        currentQuestion = game.pickRandomQuestion()
        displayQuestion(question: currentQuestion!)
    }
    
    // MARK: Helper Methods
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
        self.setScreenToDefault()
        self.nextRound()
        }
    }
    func lightingMode() -> DispatchWorkItem {
        let timer = 15
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(timer))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        let lighting = DispatchWorkItem(block: {
            //set the screen for ran out of time message, play wrong answer sound
            self.setScreenOutOfTime()
            self.game.playWrongAnswerSound()
            self.loadNextRoundWithDelay(seconds: 2)
        })
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: lighting)
        
        return lighting
    }
    

}

