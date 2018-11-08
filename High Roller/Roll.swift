/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

struct Roll {

  var dice: [Dice] = []
  var numberOfSides = 6

  mutating func changeNumberOfDice(newDiceCount: Int) {
    dice = []
    for _ in 0 ..< newDiceCount {
      dice.append(Dice())
    }
  }

  var allDiceValues: [Int] {
    return dice.flatMap { $0.value}
  }

  mutating func rollAll() {
    for index in 0 ..< dice.count {
      dice[index].rollDie(numberOfSides: numberOfSides)
    }
  }

  mutating func changeValueForDie(at diceIndex: Int, to newValue: Int) {
    if diceIndex < dice.count {
      dice[diceIndex].value = newValue
    }
  }

  func totalForDice() -> Int {
    let total = dice
      .flatMap { $0.value }
      // .reduce(0) { $0 - $1 }       // bug line
      .reduce(0) { $0 + $1 }          // fixed
    return total
  }
  
}
