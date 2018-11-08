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

class RollTests: XCTestCase {

  var roll: Roll!

  override func setUp() {
    super.setUp()

    roll = Roll()
    roll.changeNumberOfDice(newDiceCount: 5)
  }

  func testCreatingRollOfDice() {
    XCTAssertNotNil(roll)
    XCTAssertEqual(roll.dice.count, 5)
  }

  func testTotalForDiceBeforeRolling_ShouldBeZero() {
    let total = roll.totalForDice()
    XCTAssertEqual(total, 0)
  }

  func testTotalForDiceAfterRolling_ShouldBeBetween5And30() {
    roll.rollAll()
    let total = roll.totalForDice()
    XCTAssertGreaterThanOrEqual(total, 5)
    XCTAssertLessThanOrEqual(total, 30)
  }
  
}
