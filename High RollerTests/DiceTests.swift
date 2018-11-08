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

import XCTest
@testable import High_Roller

class DiceTests: XCTestCase {

  func testForDice() {
    let _ = Dice()
  }

  // 1
  func testValueForNewDiceIsNil() {
    let testDie = Dice()

    // 2
    XCTAssertNil(testDie.value, "Die value should be nil after init")
  }

  func testRollDie() {
    var testDie = Dice()
    testDie.rollDie()

    XCTAssertNotNil(testDie.value)
  }

  func testDiceRoll_ShouldBeFromOneToSix() {
    var testDie = Dice()
    testDie.rollDie()

    XCTAssertTrue(testDie.value! >= 1)
    XCTAssertTrue(testDie.value! <= 6)
    XCTAssertFalse(testDie.value == 0)
  }

  func testRollsAreSpreadRoughlyEvenly() {
    performMultipleRollTests()
  }

  func testRollingTwentySidedDice() {
    var testDie = Dice()
    testDie.rollDie(numberOfSides: 20)

    XCTAssertNotNil(testDie.value)
    XCTAssertTrue(testDie.value! >= 1)
    XCTAssertTrue(testDie.value! <= 20)
  }

  func testTwentySidedRollsAreSpreadRoughlyEvenly() {
    performMultipleRollTests(numberOfSides: 20)
  }

}


extension DiceTests {

  fileprivate func performMultipleRollTests(numberOfSides: Int = 6, line: UInt = #line) {
    var testDie = Dice()
    var rolls: [Int: Double] = [:]
    let rollCounter = Double(numberOfSides) * 100.0
    let expectedResult = rollCounter / Double(numberOfSides)
    let allowedAccuracy = rollCounter / Double(numberOfSides) * 0.3

    for _ in 0 ..< Int(rollCounter) {
      testDie.rollDie(numberOfSides: numberOfSides)
      guard let newRoll = testDie.value else {
        XCTFail()
        return
      }

      if let existingCount = rolls[newRoll] {
        rolls[newRoll] = existingCount + 1
      } else {
        rolls[newRoll] = 1
      }
    }

    XCTAssertEqual(rolls.keys.count, numberOfSides, line: line)

    for (key, roll) in rolls {
      XCTAssertEqualWithAccuracy(roll,
                                 expectedResult,
                                 accuracy: allowedAccuracy,
                                 "Dice gave \(roll) x \(key)",
                                 line: line)
    }
  }
  
}


