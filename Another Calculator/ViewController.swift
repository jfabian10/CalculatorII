//
//  ViewController.swift
//  Another Calculator
//
//  Created by Jesus Bill Fabian Jr on 1/5/16.
//  Copyright © 2016 Jesus S. B. Fabian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// The text display at the top of the UI.
    @IBOutlet weak var display: UILabel!
    /// The status of whether we're typing on display or not.
    var userIsInTheMiddleOfTypingNumber = false
    /// The model class of our calculator.
    var brain = CalculatorBrain()  //arrow that goes from controller to model
    
    
    
    /**
     Gets called as user is typing a number.
     - Parameters sender: any number button
    */
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
           display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    
    /**
     Gets called when user clicks on a operation button of the UI.
     - Parameter sender: any button such as +, -, *, etc.
    */
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber{ //anytime you an operator is pressed you want to give use automatic enter e.g. '6' + 'enter' + '3' + 'enter' + 'x'  will be reduced to '6' + 'enter' + '3' + 'x'
            
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
        }
                
            // TO BE FIXED
        else {
            displayValue = 0
        }
    }
}
    /**
     Called when user clicks on return button.
    */

    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }
        else {
            displayValue = 0  ///we want to make displayValue an optional. TO BE FIXED
        }
        
    }
    
    /// The actual value of what's in display converted to a Double
    var displayValue: Double {
        get { //convert value in display to a double
            return (display.text! as NSString).doubleValue
            
        }
        set { // newValue is a variable that belongs to set()
            display.text = "\(newValue)"  //converts it to a string
            userIsInTheMiddleOfTypingNumber = false  //if someone set the display value we aren't in the middle of typing anymore
        }
    }
}

