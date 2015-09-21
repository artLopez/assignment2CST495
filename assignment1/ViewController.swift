//
//  ViewController.swift
//  assignment1
//
//  Created by Arturo Lopez on 9/13/15.
//  Copyright (c) 2015 Arturo Lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var inputHistory: UILabel!
    
    var userMiddleOfTypingNumber = false
    var hasDecimal = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let currentText = display.text!
        
        if userMiddleOfTypingNumber{
            if( digit == "." && currentText.rangeOfString(".") == nil &&
                currentText.rangeOfString("π") == nil || digit != "." && digit != "π"){
                display.text = display.text! + digit
                inputHistory.text = inputHistory.text! + digit
            }
        }
        else {
            checkIfPi(digit)
            inputHistory.text = inputHistory.text! + " " + digit
            userMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func clearButton(sender: UIButton) {
        operandStack.removeAll()
        display.text = "0"
        userMiddleOfTypingNumber = false
        inputHistory.text = ""
    }
    @IBAction func operate(sender: UIButton) {
        if checkDoubleOperation(sender.currentTitle!) && operandStack.count > 1{
            inputHistory.text = inputHistory.text! + " " + sender.currentTitle!
        }
        
        if userMiddleOfTypingNumber{
            enter()
        }
        if let operation = sender.currentTitle{
            switch operation {
            case "×": performOperation{ $0 * $1}
            case "÷": performOperation{ $1 / $0}
            case "+": performOperation{ $0 + $1}
            case "−": performOperation{ $1 - $0}
            case "√" : performOperation { sqrt($0)}
                    stackHasValues(operation)
            case "sin": performOperation{ sin($0) }
                      stackHasValues(operation)
            case "cos": performOperation{ cos($0) }
                      stackHasValues(operation)
                
            default: break
            }
        }
    }
    
    func checkIfPi(digit: String){
        if(digit ==  "π"){
            display.text = "3.14159"
        }else{
            display.text = digit
        }
    }
    
    func checkDoubleOperation(operation: String) -> Bool{
        if operation == "×" || operation == "+" ||
                        operation == "−" || operation == "÷"{
            return true
        }
        return false
    }
    
    func stackHasValues(operation: String){
        if( operandStack.count > 0){
                inputHistory.text = inputHistory.text! + " " + operation
        }
    }
    
    
    func performOperation(operation: (Double,Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
  
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()

    @IBAction func enter() {
        userMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get{
            if(display.text! == "π"){
                return M_PI
            }
            else{
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        }
        set{
            display.text = "\(newValue)"
            userMiddleOfTypingNumber = false
        }
    }
}

