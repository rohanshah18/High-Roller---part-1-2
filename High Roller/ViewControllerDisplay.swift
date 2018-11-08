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

import Cocoa

// MARK: - Display methods


extension ViewController {


  func displayDiceFromRoll(diceRolls: [Int], numberOfSides: Int = 6) {
    clearExistingDisplay()
    if diceRolls.isEmpty { return }

    resultsTextView.string = textDisplayForRoll(diceRolls: diceRolls, numberOfSides: numberOfSides)

    let subviews = graphicalDisplayForRoll(diceRolls: diceRolls, numberOfSides: numberOfSides)
    for subview in subviews {
      resultsStackView.addView(subview, in: .top)
    }
  }

  // MARK: - Private functions

  private func clearExistingDisplay() {
    resultsTextView.string = ""

    for subview in resultsStackView.views {
      resultsStackView.removeView(subview)
    }
  }

  private func textDisplayForRoll(diceRolls: [Int], numberOfSides: Int) -> String {
    let total = diceRolls.reduce(0) { $0 + $1 }
    let validDiceValuesString = diceRolls
      .map { String($0) }
      .joined(separator: ", ")

    var resultString = "Total rolled: \(total)\n"
    resultString += "Dice rolled: \(validDiceValuesString) "
    resultString += "(\(diceRolls.count) x \(numberOfSides) sided dice)\n"

    var allRolls: [Int: Int] = [:]
    for value in diceRolls {
      if let existingCount = allRolls[value] {
        allRolls[value] = existingCount + 1
      } else {
        allRolls[value] = 1
      }
    }

    resultString += "You rolled:"
    var rollCountArray: [String] = []
    let keys = allRolls.keys.sorted()
    for key in keys {
      rollCountArray.append(" \(allRolls[key]!) x \(key)s")
    }
    resultString += rollCountArray.joined(separator: ", ")

    return resultString
  }

  private func graphicalDisplayForRoll(diceRolls: [Int], numberOfSides: Int) -> [NSView] {
    let showDiceImages = (numberOfSides <= 6) ? true : false
    let widthPerDice = (numberOfSides <= 8) ? 40 : 70

    let maxNumberOfDiceInDisplay = Int(resultsStackView.frame.width) / widthPerDice
    if diceRolls.count > maxNumberOfDiceInDisplay {
      return unableToShowGraphicalView()
    }

    var viewsForStack: [NSView] = []

    for dieValue in diceRolls {
      let newTextField = blankTextField()
      newTextField.isBordered = !showDiceImages
      newTextField.attributedStringValue = diceDisplayForNumber(diceValue: dieValue,
                                                                showDiceImages: showDiceImages)
      viewsForStack.append(newTextField)
    }

    return viewsForStack
  }

  private func blankTextField() -> NSTextField {
    let newTextField = NSTextField()
    newTextField.backgroundColor = NSColor.controlColor
    newTextField.isEditable = false
    newTextField.isSelectable = false

    return newTextField
  }

  private func unableToShowGraphicalView() -> [NSView] {
    let newTextField = blankTextField()
    newTextField.isBordered = false

    let message = "The window is too small to display the dice graphically."
    let attributedString = createAttributedString(string: message, fontSize: 16, lineHeight: 38)
    newTextField.attributedStringValue = attributedString

    return [newTextField]
  }

  private func diceDisplayForNumber(diceValue: Int, showDiceImages: Bool) ->
    NSMutableAttributedString {
      var stringForValue = String(diceValue)

      // use the Unicode values to get the characters for the 6-sided dice faces
      if showDiceImages {
        switch diceValue {
        case 1:
          stringForValue = "\u{2680}"
        case 2:
          stringForValue = "\u{2681}"
        case 3:
          stringForValue = "\u{2682}"
        case 4:
          stringForValue = "\u{2683}"
        case 5:
          stringForValue = "\u{2684}"
        case 6:
          stringForValue = "\u{2685}"
        default:
          stringForValue = String(diceValue)
        }
      }

      let lineHeight: CGFloat = showDiceImages ? 58 : 50
      let fontSize: CGFloat = showDiceImages ? 60 : 40

      let attributedString = createAttributedString(string: stringForValue,
                                                    fontSize: fontSize,
                                                    lineHeight: lineHeight)

      return attributedString
  }

  private func createAttributedString(string: String,
                                      fontSize: CGFloat,
                                      lineHeight: CGFloat) -> NSMutableAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.maximumLineHeight = lineHeight
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.alignment = .center

    let font = NSFont.systemFont(ofSize: fontSize)

    let textAttributes: [String: AnyObject] = [
      NSParagraphStyleAttributeName: paragraphStyle,
      NSFontAttributeName: font
    ]

    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: textAttributes)
    
    return attributedString
  }
  
}
