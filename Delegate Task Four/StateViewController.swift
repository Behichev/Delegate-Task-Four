//
//  ViewController.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 26.12.2022.
//

import UIKit
protocol StateViewControllerDelegate {
    func segmentedControlDidChange(control state: Int)
}
class StateViewController: UIViewController {

    @IBOutlet weak private var stateTextView: UITextView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak private var uiStyleSegmentedControl: UISegmentedControl!
    
    var delegate: StateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction private func goButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: AppConstants.Identifieers.Segues.segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.Identifieers.Segues.segueIdentifier {
            if let secondScreen = segue.destination as? ConfigurationViewController {
                secondScreen.delegate = self
            }
        }
    }
}

extension StateViewController: ConfigurationViewControllerDelegate {
    func sendMessageToLabel(message: String) {
        stateLabel.text = message
    }
    
    func switchStateDidChange(state: Bool, index: Int) {
        //
    }
}
