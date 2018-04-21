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
        currentQuestion = game.pickRandomQuestion()
        displayQuestion(question: currentQuestion!) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //resets all the answer buttons to their default state
    func setButtonsToDefault(){
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
    }
    
    //update the question label and the answer buttons
    func displayQuestion(question: Question) {
        currentQuestion = question
        questionField.text = question.question
        option1Button.setTitle(question.option1, for: .normal)
        option2Button.setTitle(question.option2, for: .normal)
        option3Button.setTitle(question.option3, for: .normal)
        option4Button.setTitle(question.option4, for: .normal)
        self.setButtonsToDefault()
        gameTimer = self.lightingMode()
    }
    
    //Show the final score, hide the answer buttons, show the play again button
    func displayScore() {
        // Hide the answer buttons
        option1Button.isHidden = true
        option2Button.isHidden = true
        option3Button.isHidden = true
        option4Button.isHidden = true

        // Display play again button
        playAgainButton.isHidden = false
        game.playGameEndSound()
        questionField.text = "Way to go!\nYou got \(game.correctAnswers) out of \(game.totalQuestions) correct!"
        
    }
    
    //answer button touch up inside event
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        //check if the selected answer is correct
        let correctAnswer = currentQuestion?.correctAnswer
        if ((sender === option1Button &&  correctAnswer == 1) ||
            (sender === option2Button && correctAnswer == 2) ||
            (sender === option3Button && correctAnswer == 3) ||
            (sender === option4Button && correctAnswer == 4)) {
            game.correctAnswers += 1
            questionField.text = "Correct!"
            game.playCorrectAnswerSound()
        } else {
            
            questionField.text = "Sorry, wrong answer!"
            game.playWrongAnswerSound()
        }
        
        //style the answer buttons to show the correct answer
        if let answer = correctAnswer {
            let correctAnswerColor = UIColor.init(red: 51/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1)
            switch answer {
            case 1:
                option1Button.setTitleColor(UIColor.black, for: .normal)
                option1Button.backgroundColor = correctAnswerColor
            case 2:
                option2Button.setTitleColor(UIColor.black, for: .normal)
                option2Button.backgroundColor = correctAnswerColor
            case 3:
                option3Button.setTitleColor(UIColor.black, for: .normal)
                option3Button.backgroundColor = correctAnswerColor
            case 4:
                option4Button.setTitleColor(UIColor.black, for: .normal)
                option4Button.backgroundColor = correctAnswerColor
            default:
                self.setButtonsToDefault()
            }
        }
        //cancel lighting mode
        if let timer = gameTimer  {
            timer.cancel()
        }
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
            self.questionField.text = "Outta time!"
            self.game.playWrongAnswerSound()
            self.option1Button.isHidden = true
            self.option2Button.isHidden = true
            self.option3Button.isHidden = true
            self.option4Button.isHidden = true
            
            self.loadNextRoundWithDelay(seconds: 2)
        })
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: lighting)
        //lighting.cancel()
        return lighting
    }
    

}

