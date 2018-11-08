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

class ViewController: NSViewController {

  @IBOutlet weak var numberOfDiceTextField: NSTextField!
  @IBOutlet weak var numberOfDiceStepper: NSStepper!
  @IBOutlet weak var numberOfSidesPopup: NSPopUpButton!

  @IBOutlet weak var resultsStackView: NSStackView!
  @IBOutlet var resultsTextView: NSTextView!

  @IBOutlet weak var rollButton: NSButton!

  var roll: Roll!
  var webSource: WebSource!


  override func viewDidLoad() {
    super.viewDidLoad()

    roll = Roll()
    roll.numberOfSides = 6
    roll.changeNumberOfDice(newDiceCount: 2)
  }

    override var representedObject: Any? {
      didSet {
        // Update the view, if already loaded.
      }
    }

}

// MARK: - Actions

extension ViewController {


  @IBAction func numberOfDiceTextFieldChanged(_ sender: NSTextField) {
    let maxDiceCount = 20

    if let newDiceCount = Int(sender.stringValue), newDiceCount <= maxDiceCount {
      numberOfDiceStepper.integerValue = newDiceCount
      roll.changeNumberOfDice(newDiceCount: newDiceCount)
    } else {
      numberOfDiceTextField.stringValue = String(maxDiceCount)
      numberOfDiceStepper.integerValue = maxDiceCount
      roll.changeNumberOfDice(newDiceCount: maxDiceCount)
    }
  }

  @IBAction func numberOfDiceStepperChanged(_ sender: NSStepper) {
    let newDiceCount = sender.integerValue
    roll.changeNumberOfDice(newDiceCount: newDiceCount)
    numberOfDiceTextField.stringValue = String(newDiceCount)
  }

  @IBAction func numberOfSidesPopupChanged(_ sender: NSPopUpButton) {
    guard let selectedSidesString = sender.titleOfSelectedItem,
      let selectedSides = Int(selectedSidesString) else {
        return
    }

    roll.numberOfSides = selectedSides
  }

  @IBAction func rollButtonClicked(_ sender: NSButton) {
    numberOfDiceTextFieldChanged(numberOfDiceTextField)

    roll.rollAll()
    displayDiceFromRoll(diceRolls: roll.allDiceValues, numberOfSides: roll.numberOfSides)
  }

  @IBAction func getRollDataFromWebButtonClicked(_ sender: NSButton) {
    sender.isEnabled = false
    displayDiceFromRoll(diceRolls: [])
    resultsTextView.string = "Looking for dice roll online…"

    let numberOfDice = min(numberOfDiceStepper.integerValue, 20)
    roll.changeNumberOfDice(newDiceCount: numberOfDice)

    roll.numberOfSides = 6
    numberOfSidesPopup.selectItem(withTitle: "6")

    webSource = WebSource()
    webSource.findRollOnline(numberOfDice: numberOfDice) { (result) in
      for (index, webDieRoll) in result.enumerated() {
        self.roll.changeValueForDie(at: index, to: webDieRoll)
      }

      DispatchQueue.main.async {
        self.displayDiceFromRoll(diceRolls: self.roll.allDiceValues,
                                 numberOfSides: self.roll.numberOfSides)
        sender.isEnabled = true
      }
    }
  }
  
}
