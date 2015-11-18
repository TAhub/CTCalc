//
//  CalculatorModel.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import Foundation

struct Token
{
	var symbol:String
	var order:Int
	var effect0:(()->(Double))?
	var effect1:((Double)->(Double))?
	var effect2:((Double, Double)->(Double))?
	var functionReplace:String?
	
	init(symbol:String, order:Int, effect0:(()->(Double))? = nil, effect1:((Double)->(Double))? = nil, effect2:((Double, Double)->(Double))? = nil, functionReplace: String? = nil)
	{
		self.symbol = symbol
		self.order = order
		self.effect0 = effect0
		self.effect1 = effect1
		self.effect2 = effect2
		self.functionReplace = functionReplace
	}
	
	var before:Bool
	{
		return self.order == kOrderOperandBefore
	}
	
	var variables:Int
	{
		if effect2 != nil
		{
			return 2
		}
		if effect1 != nil
		{
			return 1
		}
		return 0
	}
}

let kOrderEffectBack = -1
let kOrderEffectClear = -2
let kOrderEffectNothing = -3
let kOrderFunc = 1
let kOrderOperandBefore = 2
let kOrderOperand = 3
let kOrderLiteral = 4

//default functions
//let kTokenPlus = Token(symbol: "+", order: 4, effect0: nil, effect1: nil, effect2: +)
//let kTokenMinus = Token(symbol: "−", order: 5, effect0: nil, effect1: nil, effect2: -)
//let kTokenMult = Token(symbol: "×", order: kOrderOperand, effect0: nil, effect1: nil, effect2: *)
//let kTokenDiv = Token(symbol: "÷", order: 3, effect0: nil, effect1: nil, effect2: /)
let kTokenPlus = Token(symbol: "+", order: kOrderOperand, effect0: nil, effect1: nil, effect2: +)
let kTokenMinus = Token(symbol: "−", order: kOrderOperand, effect0: nil, effect1: nil, effect2: -)
let kTokenMult = Token(symbol: "×", order: kOrderOperand, effect0: nil, effect1: nil, effect2: *)
let kTokenDiv = Token(symbol: "÷", order: kOrderOperand, effect0: nil, effect1: nil, effect2: /)
let kTokenSin = Token(symbol: "sin", order: kOrderOperand, effect0: nil, effect1: sin)
let kTokenCos = Token(symbol: "cos", order: kOrderOperand, effect0: nil, effect1: cos)
let kTokenTan = Token(symbol: "tan", order: kOrderOperand, effect0: nil, effect1: tan)
let kTokenExp = Token(symbol: "^", order: kOrderOperand, effect0: nil, effect1: nil, effect2: { pow($0, $1) })
let kTokenSquare = Token(symbol: "²", order: kOrderOperand, effect0: nil, effect1: { pow($0, 2) })
let kTokenCube = Token(symbol: "³", order: kOrderOperand, effect0: nil, effect1: { pow($0, 3) })
let kTokenSquareRoot = Token(symbol: "√", order: kOrderOperandBefore, effect0: nil, effect1: sqrt, effect2: nil, functionReplace: nil)
let kTokenCubeRoot = Token(symbol: "∛", order: kOrderOperand, effect0: nil, effect1: { pow($0, 1.0 / 3) })
let kTokenPi = Token(symbol: "π", order: kOrderOperand, effect0: { M_PI })
let kTokenNaturalLog = Token(symbol: "ln", order: kOrderOperand, effect0: nil, effect1: { log($0) })
let kTokenLog = Token(symbol: "log", order: kOrderOperand, effect0: nil, effect1: { log10($0) })
let kTokenEuler = Token(symbol: "e", order: kOrderOperand, effect0: { M_E })

//example function token
let kSample = Token(symbol: "samp", order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: "A + B × C")

//special tokens
let kTokenSParen = Token(symbol: "(", order: 0)
let kTokenEParen = Token(symbol: ")", order: 0)
let kTokenComma = Token(symbol: ",", order: 0)
let kTokenZero = Token(symbol: "0", order: 0)
let kTokenOne = Token(symbol: "1", order: 0)
let kTokenTwo = Token(symbol: "2", order: 0)
let kTokenThree = Token(symbol: "3", order: 0)
let kTokenFour = Token(symbol: "4", order: 0)
let kTokenFive = Token(symbol: "5", order: 0)
let kTokenSix = Token(symbol: "6", order: 0)
let kTokenSeven = Token(symbol: "7", order: 0)
let kTokenEight = Token(symbol: "8", order: 0)
let kTokenNine = Token(symbol: "9", order: 0)
let kTokenDot = Token(symbol: ".", order: 0)
let kTokenInverse = Token(symbol: "⁻", order: 0)
let kTokenA = Token(symbol: "A", order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: "1")
let kTokenB = Token(symbol: "B", order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: "1")
let kTokenC = Token(symbol: "C", order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: "1")
let kTokenD = Token(symbol: "D", order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: "1")
let kTokenE = Token(symbol: "E", order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: "1")

//effect tokens
let kTokenBack = Token(symbol: "←", order: kOrderEffectBack)
let kTokenClear = Token(symbol: "©", order: kOrderEffectClear)
let kTokenBlank = Token(symbol: " ", order: kOrderEffectNothing)

let kDefaultTokens = [kTokenPlus, kTokenMinus, kTokenMult, kTokenDiv, kTokenSin, kTokenCos, kTokenTan, kTokenExp, kTokenSquare, kTokenCube, kTokenSquareRoot, kTokenCubeRoot, kTokenSParen, kTokenEParen, kTokenComma, kTokenZero, kTokenOne, kTokenTwo, kTokenThree, kTokenFour, kTokenFive, kTokenSix, kTokenSeven, kTokenEight, kTokenNine, kTokenA, kTokenB, kTokenC, kTokenD, kTokenE, kTokenDot, kTokenPi, kTokenBlank, kTokenBack, kTokenClear, kTokenNaturalLog, kTokenEuler, kTokenLog, kTokenInverse]

enum CalculatorError:ErrorType
{
	case WhyDoINeedMultipleCases(String)
}

class CalculatorModel
{
	private var tokens = [Token]()
	
	//MARK: internal
	private func collapseTokens(tokens:[Token]) throws -> Double
	{
		var tokens = tokens
		
		//first, cut the parens out and return values
		var parenStart = 0
		var parenLevel = 0
		for (i, token) in tokens.enumerate()
		{
			if token.symbol == "("
			{
				parenStart = i
				parenLevel += 1
			}
			if token.symbol == ")" || token.symbol == ","
			{
				parenLevel -= 1
				if parenLevel == 0
				{
					//collapse that parenthesis
					let slice = tokens[(parenStart + 1)...(i - 1)]
					let sliceAr = Array<Token>(slice)
					
					//empty parentheses like () will result in an empty array; guard against that
					guard sliceAr.count > 0 else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
					
					//get its value
					let value = try collapseTokens(sliceAr)
					
					//insert the value
					tokens.removeRange(parenStart...i)
					tokens.insert(Token(symbol: "num", order: kOrderLiteral, effect0: { value }, effect1: nil, effect2: nil, functionReplace: nil), atIndex: parenStart)
					
					if token.symbol == ","
					{
						tokens.insert(kTokenSParen, atIndex: parenStart + 1)
					}
					
					//and start over
					return try collapseTokens(tokens)
				}
			}
		}
		guard parenLevel == 0 else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
		
		
		//next, collapse all numbers into values
		var numStart:Int?
		for (i, token) in tokens.enumerate()
		{
			if token.order == 0
			{
				if numStart == nil
				{
					numStart = i
				}
				
				if numStart != nil && tokens.count == i + 1 || tokens[i + 1].order != 0
				{
					//the next token ISN'T a number, so collapse here
					var number = ""
					for j in numStart!...i
					{
						number += "\(tokens[j].symbol)"
					}
					
					//remove those tokens from the array
					tokens.removeRange(numStart!...i)
					
					//and add the number
					guard let value = Double(number) else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
					tokens.insert(Token(symbol: "num", order: kOrderLiteral, effect0: { value }), atIndex: numStart!)
					
					//and start over
					return try collapseTokens(tokens)
				}
			}
		}
		
		//replace token functions with their real operations
		for (i, token) in tokens.enumerate()
		{
			if let functionReplace = token.functionReplace
			{
				var functionTokens = try tokensFromFunctionString(functionReplace)
				let functionVariables = variablesFromTokens(functionTokens)
				
				guard i + functionVariables.count < tokens.count else { throw CalculatorError.WhyDoINeedMultipleCases("NOT ENOUGH ARGUMENTS") }
				
				//TODO: get the next functionVariables.count tokens
				//if there aren't enough, throw an error
				
				var functionVariableResults = [Token]()
				for _ in 0..<functionVariables.count
				{
					functionVariableResults.append(tokens[i + functionVariableResults.count + 1])
				}
				
				//replace the variables
				for j in 0..<functionVariables.count
				{
					for k in 0..<functionTokens.count
					{
						if functionTokens[k].symbol == functionVariables[j]
						{
							functionTokens[k] = functionVariableResults[j]
						}
					}
				}
				
				//remove the tokens
				tokens.removeRange(i...(i+functionVariables.count))
				
				//add in the function
				tokens.insertContentsOf(functionTokens, at: i)
				
				//and start over
				return try collapseTokens(tokens)
			}
		}
		
		return try collapseTokensInner(tokens, order: 2)
	}
	
	private func variablesFromTokens(tokens:[Token]) -> [String]
	{
		var variables = [String]()
		for token in tokens
		{
			switch(token.symbol)
			{
			case "A": fallthrough
			case "B": fallthrough
			case "C": fallthrough
			case "D": fallthrough
			case "E":
				if !variables.contains(token.symbol)
				{
					variables.append(token.symbol)
				}
			default: break
			}
		}
		
		//alphabetize them
		variables.sortInPlace({ $0 < $1 })
		
		return variables
	}
	
	private func tokensFromFunctionString(functionString:String) throws -> [Token]
	{
		var tokens = [Token]()
		
		//translate the pieces into tokens
		let defaultTokenSymbols = kDefaultTokens.map() { $0.symbol }
		let broken = functionString.componentsSeparatedByString(" ")
		
		for t in broken
		{
			if let defaultPos = defaultTokenSymbols.indexOf(t)
			{
				tokens.append(kDefaultTokens[defaultPos])
			}
			else
			{
				throw CalculatorError.WhyDoINeedMultipleCases("BAD FUNCTION")
			}
		}
		
		return tokens
	}
	
	private func collapseTokensInner(tokens:[Token], order:Int) throws -> Double
	{
		guard tokens.count != 0 else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
		
		//special case if there's only one thing left
		if tokens.count == 1
		{
			if tokens[0].variables == 0
			{
				//just return the value
				return tokens[0].effect0!()
			}
			else
			{
				//oops, this is a pretty bad place for a non-zero variable token!
				throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX")
			}
		}
		
		var tokens = tokens
		
		//collapse things in increasing order
		for (i, token) in tokens.enumerate()
		{
			if token.order == order
			{
				//collapse it!
				switch(token.variables)
				{
				case 2:
					//oops, it needs stuff on both sides
					guard i > 0 && i < tokens.count - 1 else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
					
					//get the value
					let bef = tokens[i - 1]
					let aft = tokens[i + 1]
					let value = token.effect2!(try collapseTokensInner([bef], order: order), try collapseTokensInner([aft], order: order))

					//remove the subtring
					tokens.removeRange((i-1)...(i+1))
					tokens.insert(Token(symbol: "num", order: kOrderLiteral, effect0: { value }), atIndex: i - 1)
					return try collapseTokensInner(tokens, order: order)
				case 1:
					//get the value
					let other:Token
					if token.before
					{
						guard i < tokens.count - 1 else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
						other = tokens[i + 1]
					}
					else
					{
						guard i > 0 else { throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX") }
						other = tokens[i - 1]
					}
					let value = token.effect1!(try collapseTokensInner([other], order: order))
					
					//remove the subtring
					if token.before
					{
						tokens.removeRange(i...(i+1))
						tokens.insert(Token(symbol: "num", order: kOrderLiteral, effect0: { value }), atIndex: i)
					}
					else
					{
						tokens.removeRange((i-1)...i)
						tokens.insert(Token(symbol: "num", order: kOrderLiteral, effect0: { value }), atIndex: i - 1)
					}
					return try collapseTokensInner(tokens, order: order)
				case 0: break //nothing happens
				default: throw CalculatorError.WhyDoINeedMultipleCases("BAD TOKEN")
				}
			}
		}
		
		if order == 10
		{
			//this is bad syntax
			//it has probably ended up with multiple number literals in a row
			throw CalculatorError.WhyDoINeedMultipleCases("BAD SYNTAX")
		}
		
		//you didn't find anything of this order
		return try collapseTokensInner(tokens, order: order + 1)
	}
	
	//MARK: input
	func applyToken(token:Token)
	{
		switch(token.order)
		{
		case kOrderEffectBack:
			tokens.popLast()
			return
		case kOrderEffectClear:
			tokens = [Token]()
			return
		case kOrderEffectNothing: return
		default: break
		}
		
		tokens.append(token)
		
		if let functionString = token.functionReplace
		{
			do
			{
				let functionTokens = try tokensFromFunctionString(functionString)
				let functionVariables = variablesFromTokens(functionTokens)
				
				if functionVariables.count > 0
				{
					//add a parenthesis
					tokens.append(kTokenSParen)
				}
			}
			catch _
			{
				//it's a bad function
				print("ERROR: failed to read function")
			}
		}
	}
	
	//MARK: output
	var result:String
	{
		do
		{
			let r = try collapseTokens(tokens)
			if Double(Int(r)) == r
			{
				return "\(Int(r))"
			}
			return "\(r)"
		}
		catch CalculatorError.WhyDoINeedMultipleCases(let name)
		{
			return name
		}
		catch _
		{
			return "SWIFT ERROR"
		}
	}
	
	var functionString:String
	{
		if tokens.count == 0
		{
			return ""
		}
		
		//automatically appends parentheses, to make sure that the function executes as a single block
		var s = "( "
		for (i, token) in tokens.enumerate()
		{
			s += token.symbol
			if i != tokens.count - 1
			{
				s += " "
			}
		}
		return "\(s) )"
	}
	
	var tokenString:String
	{
		return tokens.reduce("", combine: {$0 + $1.symbol})
	}
}