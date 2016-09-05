//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Вадим Коппе on 28.08.16.
//  Copyright © 2016 Вадим Коппе. All rights reserved.
//

import Foundation

class CalculatorModel {
    
    fileprivate var accumulator = 0.0
    
    typealias PropertyList = AnyObject
    
    fileprivate var internalProgram = [AnyObject]()
    
    fileprivate var pending: PendingBinaryOperationInfo?
    
    fileprivate struct PendingBinaryOperationInfo {
        var firstOperand: Double
        var binaryFunction: (Double, Double) -> Double
    }
    
    fileprivate var operations = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "±"  : Operation.unaryOperation({ -$0 }),
        "√"  : Operation.unaryOperation(sqrt),
        "cos"  : Operation.unaryOperation(cos),
        "×"  : Operation.binaryOperation({ $0 * $1} ),
        "÷"  : Operation.binaryOperation({ $0 / $1} ),
        "+"  : Operation.binaryOperation({ $0 + $1} ),
        "−"  : Operation.binaryOperation({ $0 - $1} ),
        "="  : Operation.equals
    ]
    
    fileprivate  enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    
    }
    
    fileprivate func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    internal func clear() {
        pending = nil
        accumulator = 0.0
        internalProgram.removeAll()
    }
    
    internal func setOperand(_ operand: Double) {
        accumulator = operand
        
        internalProgram.append(operand as AnyObject)
    }
    
    internal func performOperand(_ symbol: String) {
        
        internalProgram.append(symbol as AnyObject)
        
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(firstOperand: accumulator, binaryFunction: function)
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    internal var result: Double {
        get {
            return accumulator
        }
    }
    
    internal var program: PropertyList {
        get {
            return  internalProgram as PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    }else if let operation = op as? String {
                        performOperand(operation)
                    }
                }
            }
        }
    }
}
