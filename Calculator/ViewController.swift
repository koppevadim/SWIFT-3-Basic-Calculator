//
//  ViewController.swift
//  Calculator
//
//  Created by Вадим Коппе on 28.08.16.
//  Copyright © 2016 Вадим Коппе. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var display: UILabel!
    
    fileprivate var userInTheMiddleOfTheTyping = false
    
    fileprivate var brain = CalculatorModel()
    
    fileprivate var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTheTyping {
            let currentDisplayDigits = display.text!
            display.text = currentDisplayDigits + digit
        }else {
            if digit == "." {
                display.text = "0."
            }else {
                display.text = digit
            }
        }
        
        userInTheMiddleOfTheTyping = true
    }

    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTheTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTheTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperand(mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
}

