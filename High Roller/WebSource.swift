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

struct WebSource {

  // https://www.random.org/dice/?num=5

  func findRollOnline(numberOfDice: Int, completion: @escaping ( [Int] ) -> Void) {
    let address = "https://www.random.org/dice/?num=\(numberOfDice)"
    guard let url = URL(string: address) else {
      return
    }

    let request = URLRequest(url: url)

    let defaultConfiguration = URLSessionConfiguration.default
    let session = URLSession(configuration: defaultConfiguration)

    let task = session.dataTask(with: request) { (data, response, error) in
      if let data = data {
        let diceRolled = self.parseIncomingData(data: data)
        completion(diceRolled)
      } else {
        completion([])
      }
    }
    task.resume()
  }

  func parseIncomingData(data: Data) -> [Int] {
    guard let stringReceived = String(data: data, encoding: String.Encoding.ascii) else {
      return []
    }
    let stringLines = stringReceived.components(separatedBy: "\n")

    let diceLines = stringLines.filter {
      $0.range(of: "<img src=\"dice") != nil
    }

    var dice: [Int] = []

    for die in diceLines {
      let diceStart = die.index(die.startIndex, offsetBy: 14)
      let diceEnd = die.index(die.startIndex, offsetBy: 15)
      if let diceResult = Int(die.substring(to: diceEnd).substring(from: diceStart)) {
        dice.append(diceResult)
      }
    }
    
    return dice
  }
}
