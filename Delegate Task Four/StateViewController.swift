//
//  ViewController.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 26.12.2022.
//

import UIKit

class StateViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var stateTextView: UITextView!
    @IBOutlet weak private var stateLabel: UILabel!
    @IBOutlet weak private var uiStyleSegmentedControl: UISegmentedControl!
    
    //MARK: - Variables
    
    private var bunchOfSwitchStates: [Bool] = []
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...15 {
            bunchOfSwitchStates.append(false)
        }
        setupTextViewContent()
    }
    
    //MARK: - Functions
    
    private func setupTextViewContent() {
        var textElement = ""
        for (index, element) in bunchOfSwitchStates.enumerated() {
            let textValue = element ? "On" : "Off"
            textElement += "\(index): \(textValue)\n"
        }
        stateTextView.text = textElement
    }
    
    //MARK: - Actions
    
    @IBAction private func goButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: AppConstants.Identifieers.Segues.segueIdentifier, sender: self)
    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.Identifieers.Segues.segueIdentifier {
            if let secondScreen = segue.destination as? SettingsViewController {
                secondScreen.delegate = self
                if let text = stateLabel.text {
                    let configuration = SettingsViewControllerConfiguration(bunchOfSwiftStates: bunchOfSwitchStates,textForTexfield: text, selectedIndex: uiStyleSegmentedControl.selectedSegmentIndex)
                    secondScreen.configure(with: configuration)
                }
            }
        }
    }
}

//MARK: - SettingsViewControllerDelegate

extension StateViewController: SettingsViewControllerDelegate {
    func sendMessageToLabel(message: String) {
        stateLabel.text = message
    }
    
    func switchStateDidChange(state: Bool, index: Int) {
        bunchOfSwitchStates[index] = state
        setupTextViewContent()
    }
}
