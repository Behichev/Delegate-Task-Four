//
//  ViewController.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 26.12.2022.
//

import UIKit

class StateViewController: UIViewController {
    
    @IBOutlet weak private var stateTextView: UITextView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak private var uiStyleSegmentedControl: UISegmentedControl!
    
    
    private var bunchOfSwitchStates: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...9 {
            bunchOfSwitchStates.append(false)
        }
    }
    
    @IBAction private func goButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: AppConstants.Identifieers.Segues.segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.Identifieers.Segues.segueIdentifier {
            if let secondScreen = segue.destination as? SettingsViewController {
                secondScreen.delegate = self
                if let text = stateLabel.text {
                    let configuration = SettingsViewControllerConfiguration(bunchOfSwiftStates: bunchOfSwitchStates,textForTexfield: text)
                    secondScreen.configure(with: configuration)
                    secondScreen.selectedIndex = uiStyleSegmentedControl.selectedSegmentIndex
                }
            }
        }
    }
}

extension StateViewController: SettingsViewControllerDelegate {
    func sendMessageToLabel(message: String) {
        stateLabel.text = message
    }
    
    func switchStateDidChange(state: Bool, index: Int) {
        var textElement = ""
        bunchOfSwitchStates[index] = state
        
        for (index, element) in bunchOfSwitchStates.enumerated() {
            let textValue = element ? "ON" : "OFF"
            textElement += "\(index): \(textValue)\n"
        }
        stateTextView.text = textElement
    }
}
