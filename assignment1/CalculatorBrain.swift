//
//  CalculatorBrain.swift
//  assignment2
//
//  Created by Arturo Lopez on 9/20/15.
//  Copyright © 2015 Arturo Lopez. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible{
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String,(Double,Double) -> Double)
        case ConstantOperation(String)
        
        var description: String {
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let variable):
                    return variable
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                default:
                    return "nil"
            }
          }
        }
    }
    
    private var opStack = [Op]()
    private var knowOps = [String:Op]()
    var variablesValues: [String:Double]
    
    init(){
        
        func learnOp(op: Op){
            knowOps[op.description] = op
        }
        
        variablesValues = [String: Double]()
        
        knowOps["×"]   = Op.BinaryOperation("×"){$1 * $0 }
        knowOps["÷"]   = Op.BinaryOperation("÷"){$1 / $0 }
        knowOps["+"]   = Op.BinaryOperation("+"){$1 + $0}
        knowOps["−"]   = Op.BinaryOperation("−"){$1 - $0 }
        knowOps["√"]   = Op.UnaryOperation("√", sqrt)
        knowOps["sin"] = Op.UnaryOperation("sin"){ sin($0)}
        knowOps["cos"] = Op.UnaryOperation("cos"){ cos( $0 )}
        knowOps["π"]   = Op.UnaryOperation("π"){ M_PI * $0 }
    }
    
    private func descriptionHistory(ops: [Op]) -> ( result: String?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let operation, _):
                let operandEvaluation = descriptionHistory(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation + "(\(operand))", operandEvaluation.remainingOps)
                }
                return(operation + "?", operandEvaluation.remainingOps)
            case .BinaryOperation(let operation,_):
                let op1Evaluation = descriptionHistory(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = descriptionHistory(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return ("(" + operand2 + " " + operation + " " + operand1 + ")", op2Evaluation.remainingOps)
                    }
                    return ("?+" + operand1, op2Evaluation.remainingOps)
                }
            case .Variable(let variable):
                if let varVal = knowOps[variable]{
                     return("\(varVal)", remainingOps)
                }
                else{
                    return("\(variable)", remainingOps)
                }
            default:
                return(nil,remainingOps)

            }
          }
        return (nil,ops)
    }
   
        
    private func evaluate(ops: [Op]) -> ( result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let variable):
                if let varVal = knowOps[variable]{
                    let varValStr = NSString(string: varVal.description)
                    return(varValStr.doubleValue, remainingOps)
                }
                else{
                    return(nil, remainingOps)
                }
            default:
                return (nil,ops)
            }
        }
        return (nil,ops)
    }
    
    
        
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
 
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func setMVariable(valueOfM: Double) -> Double?{
        variablesValues["M"] = valueOfM
        return evaluate()
    }
    
    func removeAll(){
        opStack.removeAll()
        variablesValues.removeValueForKey("M")
    }
    
    func count() -> Int {
        return opStack.count
    }
    
    var destHistory:  String? {
        get{
            if let inputHis = descriptionHistory(opStack).result{
                return inputHis
            }
            return nil
        }
    }
}