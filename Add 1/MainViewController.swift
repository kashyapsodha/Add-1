//
//  MainViewController.swift
//  Add 1
//
//  Created by Kashyap Sodha on 3/7/19.
//  Copyright © 2019 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    var score: Int = 0
    
    var hud: MBProgressHUD?
    
    var timer: Timer?
    var seconds: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instance of HUD Property
        hud = MBProgressHUD(view: self.view)
        
        if(hud != nil) {
            self.view.addSubview(hud!)
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        inputField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if(inputField?.text?.count ?? 0 < 4) {
            return
        }
        
        // Change optional values and convert it into integer
        if let number_text = numberLabel?.text,
           let input_text = inputField?.text,
           let number = Int(number_text),
            let input = Int(input_text) {
            print("Comparing: \(input_text) minus \(number_text) == \(input - number)")
            
            // Excluding 0's from the game for this computation
            if(input - number == 1111) {
                print("Correct")
                if(score < 100) {
                    // To not allow score above '100'
                    score += 1
                }
                // score += 1 -> To allow score above '100'
                showHudWithAnswer(isRight: true)
            }
            else {
                print("Incorrect")
                if(score > 0){
                    // To not allow score below '0'
                    score -= 1
                }
                // score -= 1 -> To allow score below '0'
                showHudWithAnswer(isRight: false)
            }
        }
        setRandomNumberLabel()
        updateScoreLabel()
        
        if(timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func onUpdateTimer() -> Void {
        if(seconds > 0 && seconds <= 60) {
            seconds -= 1
            updateTimeLabel()
        }
        else if(seconds == 0) {
            if(timer != nil) {
                // Stop the timer
                timer!.invalidate()
                // Remove from memory
                timer = nil
                
                let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(score) points", preferredStyle: .alert)
                
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alertController.addAction(restartAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                score = 0
                seconds = 60
                
                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()
            }
        }
    }
    
    func updateTimeLabel() {
        if(timeLabel != nil) {
            let min: Int = (seconds / 60) % 60
            let sec: Int = seconds % 60
            
            // Comvert into zero-padded strings
            let min_p: String = String(format: "%02d", min)
            let sec_p: String = String(format: "%02d", sec)
            
            timeLabel!.text = "\(min_p):\(sec_p)"
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "\(score)"
    }
    
    func setRandomNumberLabel() {
        numberLabel?.text = generateRandomString()
    }
    
    func generateRandomString() -> String {
        var result: String = ""
        for _ in 1...4{
            // Generate a random number
            // Random generates numbers from 0 to 8. Thus, add 1 to get numbers from 1 to 9.
            let digit: Int = Int(arc4random_uniform(8) + 1)
            result += "\(digit)"
        }
        return result
    }
    
    func showHudWithAnswer(isRight: Bool) {
        var imageView: UIImageView?
        
        if isRight {
            imageView = UIImageView(image: UIImage(named: "thumbs-up"))
        }
        else {
            imageView = UIImageView(image: UIImage(named: "thumbs-down"))
        }
        
        if(imageView != nil) {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            // Delaying task using asyncAfter
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hud?.hide(animated: true)
                self.inputField?.text = ""
            }
        }
    }

}
