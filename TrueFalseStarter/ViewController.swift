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
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let the games.. begin!
        game.playGameStartSound()
        
        // show the first question
        self.displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //update the question label and the answer buttons
    func displayQuestion() {
        
        //update screen
        game.startRound()
        if let round = game.currentQuestion {
            questionField.text = round.question
            answer1Button.setTitle(round.answer1, for: .normal)
            answer2Button.setTitle(round.answer2, for: .normal)
            answer3Button.setTitle(round.answer3, for: .normal)
            answer4Button.setTitle(round.answer4, for: .normal)
            answer4Button.isHidden = true
            nextButton.isHidden = true
            game.gameTimer = self.lightingMode()
        }
        else {
            questionField.text = "Error."
        }
    }
    
    //resets all the answer buttons to their default state
    func setScreenToDefault(){
        game.defaultStyleFor(button: answer1Button)
        game.defaultStyleFor(button: answer2Button)
        game.defaultStyleFor(button: answer3Button)
        game.defaultStyleFor(button: answer4Button)
        self.answerLabel.isHidden = true
        self.questionField.isHidden = false
        nextButton.isHidden = true
        nextButton.setTitle("Next Question", for: .normal)
    }
    
    //lighting mode.  You're out of time!
    func setScreenOutOfTime(){
        self.answerLabel.isHidden = false
        self.answerLabel.textColor = UIColor.init(red: 204/255.0, green: 0, blue: 0, alpha: 0.8)
        self.answerLabel.text = "You ran out of time!"
        self.questionField.isHidden = true
        self.answer1Button.isHidden = true
        self.answer2Button.isHidden = true
        self.answer3Button.isHidden = true
        self.answer4Button.isHidden = true
        nextButton.isHidden = false
    }
    
    //highlight the answer and show the next question button
    func setScreenFor(answer: Int){
        
        switch answer {
        case 1:
            game.correctAnswerStyleFor(button: answer1Button)
            game.incorrectAnswerStyleFor(button: answer2Button)
            game.incorrectAnswerStyleFor(button: answer3Button)
            game.incorrectAnswerStyleFor(button: answer4Button)
        case 2:
            game.incorrectAnswerStyleFor(button: answer1Button)
            game.correctAnswerStyleFor(button: answer2Button)
            game.incorrectAnswerStyleFor(button: answer3Button)
            game.incorrectAnswerStyleFor(button: answer4Button)
        case 3:
            game.incorrectAnswerStyleFor(button: answer1Button)
            game.incorrectAnswerStyleFor(button: answer2Button)
            game.correctAnswerStyleFor(button: answer3Button)
            game.incorrectAnswerStyleFor(button: answer4Button)
        case 4:
            game.incorrectAnswerStyleFor(button: answer1Button)
            game.incorrectAnswerStyleFor(button: answer2Button)
            game.incorrectAnswerStyleFor(button: answer3Button)
            game.correctAnswerStyleFor(button: answer4Button)
        default:
            self.setScreenToDefault()
        }
        //show the next button
        nextButton.isHidden = false
    }
    

    
    //answer button touch up inside event
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        //only allow a question to be answered once
        if game.questionsAnswered < game.questionsAsked {
            
            //show results
            answerLabel.isHidden = false
            
            //get the selected answer from the sender
            var selectedAnswer = 0
            switch sender {
            case answer1Button:
                selectedAnswer = 1
            case answer2Button:
                selectedAnswer = 2
            case answer3Button:
                selectedAnswer = 3
            case answer4Button:
                selectedAnswer = 4
            default: selectedAnswer = 0
                
            }
            
            //is answer correct?
            let correctAnswer = game.isAnswerCorrect(question: game.currentQuestion, answer: selectedAnswer)
            if correctAnswer.isCorrect {
                answerLabel.text = "Correct!"
                answerLabel.textColor = UIColor.init(red: 0, green: 204/255.0, blue: 0, alpha: 1)

            }
            else{
                answerLabel.text = "Wrong!"
                answerLabel.textColor = UIColor.init(red: 204/255.0, green: 0, blue: 0, alpha: 0.8)
            }

            //update screen for answer results
            setScreenFor(answer: correctAnswer.answer)
            
            //cancel lighting mode since something was picked
            if let timer = game.gameTimer  {
                timer.cancel()
            }
            
            //if its the last question then show the score and a play it again button after 2 seconds
            if game.isOver {
                    nextButton.setTitle("Play Again", for: .normal)
                    nextButton.isHidden = true
                    displayScoreAfterDelay(seconds: 2)
            }
        }
    }
    //acts as a next button and a play again button
    @IBAction func playAgain() {
        
        //if there are still questions then get the next question.
        //otherwise show the score and a play again button
        if !game.isOver  {
            //show next question
            setScreenToDefault()
            displayQuestion()
        }
        else {
            // Show the answer buttons
            answer1Button.isHidden = false
            answer2Button.isHidden = false
            answer3Button.isHidden = false
            answer4Button.isHidden = false
            
            //restart game
            game.restartGame()
            setScreenToDefault()
            displayQuestion()
        }
        
    }

    //Show the final score, hide the answer buttons, show the play again button
    func displayScoreAfterDelay(seconds: Int) {
        
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            
            // Hide the answer buttons
            self.answer1Button.isHidden = true
            self.answer2Button.isHidden = true
            self.answer3Button.isHidden = true
            self.answer4Button.isHidden = true
            self.answerLabel.isHidden = true
            
            // Display play again button
            self.nextButton.setTitle("Play Again", for: .normal)
            self.nextButton.isHidden = false
            self.game.playGameEndSound()
            self.questionField.text = self.game.scoreMessage()
            self.questionField.isHidden = false
        }
    }
    
    //Lighting Modoe: only allow 15 seconds to answer the question.
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
            self.game.questionsAnswered += 1
            
            //if its the last question then show the score and a play again button after 2 seconds
            if self.game.isOver {
                self.nextButton.setTitle("Play Again", for: .normal)
                self.nextButton.isHidden = true
                self.displayScoreAfterDelay(seconds: 2)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: lighting)
        
        return lighting
    }
    

}

