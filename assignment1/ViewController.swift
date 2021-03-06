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
    var brain = CalculatorBrain()
    var hasDecimal = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let currentText = display.text!
        
        if userMiddleOfTypingNumber{
            if( digit == "." && currentText.rangeOfString(".") == nil &&
                currentText.rangeOfString("π") == nil || digit != "." && digit != "π"){
                display.text = display.text! + digit
            }
        }
        else {
            checkIfPi(digit)
            userMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func mVariable(sender: UIButton) {
        if let solution = brain.pushOperand("M"){
            displayValue = solution
        }
        else{
            inputHistory.text = "\(displayValue!)" + " M "
        }
    }
    
    @IBAction func setMVariable(sender: UIButton) {
  
        if let value = displayValue{
            if let result = brain.setMVariable(value){
                displayValue = result
            }
        }
        
        if let inputHis = brain.destHistory{
            inputHistory.text! = inputHis
        }
        
        userMiddleOfTypingNumber = false
    }
    
    @IBAction func clearButton(sender: UIButton) {
        brain.removeAll()
        display.text = "0"
        userMiddleOfTypingNumber = false
        inputHistory.text = ""
    }
    @IBAction func operate(sender: UIButton) {
        if userMiddleOfTypingNumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else{
                displayValue = 0
            }
            if let inputHistoryVal = brain.destHistory {
                inputHistory.text = inputHistoryVal + "="
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
    
    @IBAction func enter() {
        userMiddleOfTypingNumber = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
            if let inputHistoryVal = brain.destHistory {
                inputHistory.text = inputHistoryVal
            }
        }else{
            
        }
    }
    
    var displayValue: Double?{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            if let newValues = newValue {
                display.text = "\(newValues)"
            }else{
                display.text = "Error!"
            }
            userMiddleOfTypingNumber = false
        }
    }
}

