//
//  ViewController.swift
//  sbtraining
//
//  Created by Eric Hernandez on 2/9/19.
//  Copyright © 2019 Eric Hernandez. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var wordTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var chkSegmentBtn: UISegmentedControl!
    
    
    var questions = WordBank()
    var totalNumberOfQuestions = 0
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var spellingWord = ""
    let synthesizer = AVSpeechSynthesizer()
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askQuestion()
    }
    func checkBtn() {
        if (spellingWord.folding(options: .diacriticInsensitive, locale: .current)).lowercased() == wordTxt.text?.lowercased() {
            randomPositiveFeedback()
            //Wait 2 seconds before showing the next question
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                //spell next word
                //self.questionNumber += 1
                self.askQuestion()
            }
            wordTxt.text = ""
            
            //increment number of correct answers
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
        } else {
            randomTryAgain()
            numberAttempts += 1
            updateProgress()
        }
    }
    @IBAction func segmentBtn(_ sender: Any) {
        let chkBtnSegIndex = chkSegmentBtn.selectedSegmentIndex
        switch chkBtnSegIndex {
        case 0:
            checkBtn()
            chkSegmentBtn.selectedSegmentIndex = -1
        case 1:
            repeatBtn()
            chkSegmentBtn.selectedSegmentIndex = -1
        case 2:
            showBtn()
            chkSegmentBtn.setEnabled(false, forSegmentAt: 0)
        case 3:
            askQuestion()
        default:
            wordTxt.text = "There's a problem!"
        }
    }
    func repeatBtn(){
        readMe(myText: spellingWord)
    }
    func showBtn(){
        wordTxt.text = (spellingWord.folding(options: .diacriticInsensitive, locale: .current)).uppercased()
    }
    func askQuestion(){
        wordTxt.text = ""
        self.wordTxt.becomeFirstResponder()
        
        let numberOfQuestions = questions.list
        totalNumberOfQuestions = numberOfQuestions.count
        let lastQIndex = totalNumberOfQuestions - 1
        let questionIndex = Int.random(in: 0...lastQIndex)
        spellingWord = questions.list[questionIndex].spellWord
        readMe(myText: "Spell \(spellingWord).")
        chkSegmentBtn.selectedSegmentIndex = -1
        chkSegmentBtn.setEnabled(true, forSegmentAt: 0)
    }
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(8))
        readMe(myText: congratulateArray[randomPick])
    }
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
}

