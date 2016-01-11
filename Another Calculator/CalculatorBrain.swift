//
//  CalculatorBrain.swift
//  Another Calculator
//
//  Created by Jesus Bill Fabian Jr on 1/8/16.
//  Copyright © 2016 Jesus S. B. Fabian. All rights reserved.
//

import Foundation

/**

Our model class, essentially what the Calculator does.


*/

class CalculatorBrain{
    
    
    /**
     Everything user clicks will fall into one of the
     three categories. It associates data with one of the cases for enums.
     - Operand : any digit
     - UnaryOperation: any operation that requires one argument e.g square root
     - BinaryOperatio: " ..... two arguments e.g addition, multiplication, etc."
    */
     private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var desription: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
        
    }
    
    /// The array of enums, called Op.
    private var opStack = [Op]()
    /// The dictionary used to match every button user clicks. Keys: strings, values: Op. Used in performOperation()
    private var knownOps = [String: Op]()
    
    /**
    The following gets loaded up whenever calculator brain gets created.
    It assigns an Op to corresponding strings.
    */
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        
    }
    
    /**
        Recursive helper method used in evalute(). We go through the stack inspecting the top elt. every time. e.g.
        suppose stack is [6, 5, +, 4, x]. Looking at 'x' we need two operands so it recursively calls itself and now we are looking
        at 4. It knows how to evalute 4, it simply returns. Looking at next elt it's a '+', we go recursive again to get its operands.
        It gets 5, going recursive again gets the 6 and now we've evaluated the entire stack. Arriving at an operand, we stop. Every time it
        encounters an operation it goes recursively to get all the arguments.
    
        - Parameters [Op]: the stack that gets evaluated
    
        - Returns:  tuple: (result of evaluation, what's left of the stack)
    
    */
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{ //is the stack empty
            var remainingOps = ops // remainingOps has a mutable copy of the stack
            let op = remainingOps.removeLast() // op = top Op element from the stack
            
            switch op {  //default case doesn't exist b/c we exhaust every possibility
            
                case .Operand(let operand): //operand is now a constant with the value of op, in our example i.e op = x.
                    return (operand, remainingOps)
            
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps) // recursion b/c it looks for the operand to which e.g sqrt should be applied
                        if let operand = operandEvaluation.result { //it gets the Double
                            return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                        if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result{
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)  //If I run out of operands, or stack...can't find it
    
}
    /**
     Calculates the actual operation. It's an optional because suppose user clicks '+' before 
     anything else. evaluate() isn't able to return anything.
    - Returns: the double that was calculated
    */
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("Array at the beginning: \(opStack), result = \(result), current Array: \(remainder).\n")
        return result
        }
    
    
    /**
     Gets called when user presses a number.
     - Parameters operand: the double user inputs
     - Returns: the double user input into the calculator
    */
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand)) //operand is now the enum with the associated value
        return evaluate()
    }
    
    /**
     Gets called when user inputs an operation. 
     Uses dictionary knownOps.
     - Parameters symbol: the symbol user input
    */
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{  //if we can find the symbol in our dictionary
            opStack.append(operation)
            
         }
        return evaluate()
        
    }
    
    
}
